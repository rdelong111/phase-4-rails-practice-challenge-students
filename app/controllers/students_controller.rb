class StudentsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def index
    if params[:instructor_id]
      instructor = Instructor.find(params[:instructor_id])
      students = instructor.students
    else
      students = Student.all
    end
    render json: students
  end

  def create
    instructor = find(params[:instructor_id])
    student = instructor.students.create!(student_params)
    render json: student, status: :created
  end

  def show
    student = find_student
    render json: student
  end

  def update
    student = find_student
    student.update!(student_params)
    render json: student
  end

  def destroy
    student = find_student
    student.destroy
    head :no_content
  end

  private

  def find_student
    Student.find(params[:id])
  end

  def student_params
    params.permit(:name, :major, :age)
  end

  def render_not_found_response
    render json: {error: "Student not found"}, status: :not_found
  end

  def render_unprocessable_entity_response(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
end
