# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_11_08_031127) do
  create_table "administrators", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "role"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_administrators_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "credits"
    t.string "name"
    t.integer "professor_id", null: false
    t.datetime "updated_at", null: false
    t.index ["professor_id"], name: "index_courses_on_professor_id"
  end

  create_table "professor_mentors_students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "professor_id", null: false
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["professor_id", "student_id"], name: "idx_on_professor_id_student_id_e35ecf3a04", unique: true
  end

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "professor_id", null: false
    t.string "research_area"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["professor_id"], name: "index_professors_on_professor_id"
    t.index ["user_id"], name: "index_professors_on_user_id"
  end

  create_table "publications", force: :cascade do |t|
    t.string "abstract"
    t.datetime "created_at", null: false
    t.string "link"
    t.string "name"
    t.date "publication_date"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_publications_on_student_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "coordinator_comments"
    t.datetime "created_at", null: false
    t.date "date_sent"
    t.string "professor_comments"
    t.datetime "review_date"
    t.string "reviewer"
    t.integer "semester"
    t.string "status"
    t.integer "student_id"
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["student_id"], name: "index_reports_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.date "join_date"
    t.date "lattes_last_update"
    t.string "lattes_link"
    t.string "name"
    t.string "pretended_career"
    t.string "role"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["student_id"], name: "index_students_on_student_id"
    t.index ["user_id"], name: "index_students_on_user_id"
  end

  create_table "takes_on_courses", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "grade"
    t.integer "student_id", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "student_id"], name: "index_takes_on_courses_on_course_id_and_student_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email", default: ""
    t.string "encrypted_password"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "login_id"
    t.string "name"
    t.string "nusp"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["login_id"], name: "index_users_on_login_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "administrators", "users"
  add_foreign_key "courses", "professors"
  add_foreign_key "professors", "professors"
  add_foreign_key "professors", "users"
  add_foreign_key "publications", "students"
  add_foreign_key "reports", "students"
  add_foreign_key "students", "students"
  add_foreign_key "students", "users"
end
