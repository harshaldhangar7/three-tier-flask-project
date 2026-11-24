
import { useEffect, useState } from 'react'

import {
    getStudents,
    addStudent,
    updateStudent,
    deleteStudent,
    checkBackendHealth
} from './services/api'

import './App.css'


function App() {

    // Store student records
    const [students, setStudents] = useState([])

    // Store form data
    const [formData, setFormData] = useState({

        name: '',

        email: '',

        course: ''

    })

    // Store selected student ID during editing
    const [editingId, setEditingId] = useState(null)

    // Store application messages
    const [message, setMessage] = useState('')

    const [error, setError] = useState('')

    // Store backend status
    const [backendStatus, setBackendStatus] = useState('Checking...')

    // Loading state
    const [loading, setLoading] = useState(false)


    // Load students from backend
    async function loadStudents() {

        try {

            const result = await getStudents()

            setStudents(result.data)

            setError('')

        } catch (err) {

            setError(err.message)

        }

    }


    // Check backend and load students
    useEffect(() => {

        async function initialize() {

            try {

                const result = await checkBackendHealth()

                setBackendStatus(result.status)

                await loadStudents()

            } catch {

                setBackendStatus('Disconnected')

                setError('Unable to connect to backend API')

            }

        }

        initialize()

    }, [])


    // Handle form input
    function handleChange(event) {

        const { name, value } = event.target

        setFormData(previous => ({

            ...previous,

            [name]: value

        }))

    }


    // Reset registration form
    function resetForm() {

        setFormData({

            name: '',

            email: '',

            course: ''

        })

        setEditingId(null)

    }


    // Submit student form
    async function handleSubmit(event) {

        event.preventDefault()

        setLoading(true)

        setMessage('')

        setError('')

        try {

            if (editingId) {

                await updateStudent(editingId, formData)

                setMessage('Student updated successfully!')

            } else {

                await addStudent(formData)

                setMessage('Student added successfully!')

            }

            resetForm()

            await loadStudents()

        } catch (err) {

            setError(err.message)

        } finally {

            setLoading(false)

        }

    }


    // Load student details into form
    function handleEdit(student) {

        setFormData({

            name: student.name,

            email: student.email,

            course: student.course

        })

        setEditingId(student.id)

        setMessage('')

        setError('')

    }


    // Delete student
    async function handleDelete(id) {

        const confirmed = window.confirm(
            'Are you sure you want to delete this student?'
        )

        if (!confirmed) return

        try {

            await deleteStudent(id)

            setMessage('Student deleted successfully!')

            if (editingId === id) {

                resetForm()

            }

            await loadStudents()

        } catch (err) {

            setError(err.message)

        }

    }


    return (

        <div className="container">

            <header className="header">

                <div>

                    <h1>Student Management System</h1>

                    <p>Three-Tier DevOps Application</p>

                </div>

                <div className="status">

                    Backend:

                    <span className={
                        backendStatus === 'healthy'
                            ? 'connected'
                            : 'disconnected'
                    }>

                        {backendStatus}

                    </span>

                </div>

            </header>


            {message && (

                <div className="success">

                    {message}

                </div>

            )}


            {error && (

                <div className="error">

                    {error}

                </div>

            )}


            <div className="content">


                {/* Student Registration Form */}

                <section className="form-section">

                    <h2>

                        {editingId
                            ? 'Update Student'
                            : 'Register Student'}

                    </h2>


                    <form onSubmit={handleSubmit}>

                        <label>Student Name</label>

                        <input
                            type="text"
                            name="name"
                            value={formData.name}
                            onChange={handleChange}
                            placeholder="Enter student name"
                            required
                            maxLength={100}
                        />


                        <label>Email Address</label>

                        <input
                            type="email"
                            name="email"
                            value={formData.email}
                            onChange={handleChange}
                            placeholder="Enter email"
                            required
                            maxLength={150}
                        />


                        <label>Course</label>

                        <input
                            type="text"
                            name="course"
                            value={formData.course}
                            onChange={handleChange}
                            placeholder="Enter course"
                            required
                            maxLength={100}
                        />


                        <button
                            type="submit"
                            disabled={loading}
                        >

                            {loading
                                ? 'Please wait...'
                                : editingId
                                    ? 'Update Student'
                                    : 'Add Student'}

                        </button>


                        {editingId && (

                            <button
                                type="button"
                                className="cancel"
                                onClick={resetForm}
                            >

                                Cancel

                            </button>

                        )}

                    </form>

                </section>


                {/* Student Records */}

                <section className="table-section">

                    <h2>Registered Students</h2>

                    <p>Total Students: {students.length}</p>


                    <div className="table-wrapper">

                        <table>

                            <thead>

                                <tr>

                                    <th>ID</th>

                                    <th>Name</th>

                                    <th>Email</th>

                                    <th>Course</th>

                                    <th>Actions</th>

                                </tr>

                            </thead>


                            <tbody>

                                {students.length === 0 ? (

                                    <tr>

                                        <td colSpan="5">
                                            No students registered yet.
                                        </td>

                                    </tr>

                                ) : (

                                    students.map(student => (

                                        <tr key={student.id}>

                                            <td>{student.id}</td>

                                            <td>{student.name}</td>

                                            <td>{student.email}</td>

                                            <td>{student.course}</td>

                                            <td>

                                                <button
                                                    className="edit"
                                                    onClick={() =>
                                                        handleEdit(student)
                                                    }
                                                >

                                                    Edit

                                                </button>


                                                <button
                                                    className="delete"
                                                    onClick={() =>
                                                        handleDelete(student.id)
                                                    }
                                                >

                                                    Delete

                                                </button>

                                            </td>

                                        </tr>

                                    ))

                                )}

                            </tbody>

                        </table>

                    </div>

                </section>

            </div>


            <footer>

                React Frontend | Flask REST API | MySQL Database

            </footer>

        </div>

    )

}


export default App
