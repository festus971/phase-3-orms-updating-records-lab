require_relative "../config/environment.rb"

  class Student
    attr_accessor :id,:grade,:name
  
    # Remember, you can access your database connection anywhere in this class
    #  with DB[:conn]
    def initialize(name,grade,id=nil)
      @name=name
      @grade=grade
      @id=id
    end
  
    def self.create_table
      query = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
  
      DB[:conn].execute(query)
    end
  
    def self.drop_table
      query = <<-SQL
      DROP TABLE IF EXISTS students
      SQL
      DB[:conn].execute(query)
    end
  
    def self.all
      DB[:conn].execute("SELECT * FROM students").map{|s| new_from_db(s)}
    end
  
    def save
      if self.id == nil
        query = INSERT INTO students (name, grade) VALUES (?, ?)
        DB[:conn].execute(query, self.name, self.grade)
        set_id
        self
      else
        self.update
      end
      
    end
  
    def self.create(name,grade)
      self.new(name,grade).save
    end
  
    def self.new_from_db(row)
      Student.new(row[1],row[2],row[0])
    end
  
    def self.find_by_name(name)
     new_from_db(DB[:conn].execute("SELECT * FROM students WHERE name=? LIMIT 1",name).first)
    end
  
    def update
      query="UPDATE students SET name=?,grade=? WHERE id=?"
      DB[:conn].execute(query, self.name, self.grade, self.id)
    end
      
  
    private
  
    def set_id
     self.id = DB[:conn].execute("SELECT last_insert_rowid()")[0][0]
    end
      
  end
  
  fe=Student.new("fe","5th")
  fe.save



