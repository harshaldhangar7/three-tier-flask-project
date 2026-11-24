
const API_BASE_URL = '/api';


// Common function for API requests
async function request(endpoint, options = {}) {

    const response = await fetch(
        `${API_BASE_URL}${endpoint}`,
        {
            ...options,
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            }
        }
    );

    const result = await response.json();

    if (!response.ok) {

        throw new Error(
            result.message || 'Something went wrong'
        );

    }

    return result;
}


// Retrieve all students
export function getStudents() {

    return request('/students');

}


// Add new student
export function addStudent(student) {

    return request('/students', {

        method: 'POST',

        body: JSON.stringify(student)

    });

}


// Update student
export function updateStudent(id, student) {

    return request(`/students/${id}`, {

        method: 'PUT',

        body: JSON.stringify(student)

    });

}


// Delete student
export function deleteStudent(id) {

    return request(`/students/${id}`, {

        method: 'DELETE'

    });

}


// Check backend health
export function checkBackendHealth() {

    return request('/health');

}
