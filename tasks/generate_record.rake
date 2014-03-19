## The MIT License (MIT)
##
## Copyright (c) 2014-2024
## Savin Max <mafei.198@gmail.com>
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.

desc "Generate Erlang Records from Rails models"
task :generate_record => :environment do
  #old_env = Rails.env
  #Rails.env = 'test'
  #Rake::Task['db:drop'].execute
  #Rake::Task['db:create'].execute
  #Rake::Task['db:migrate'].execute

  header = ""
  header << "%%%===================================================================\n"
  header << "%%% Generated by generate_record.rake #{Time.now}\n"
  header << "%%%===================================================================\n\n"

  r_string = ""
  m_string = ""
  r_string << header
  m_string << header

  m_string << "-module(model_mapping).\n"
  m_string << "-export([load/0]).\n"
  m_string << "-include(\"include/db_schema.hrl\").\n"
  m_string << "\n"
  m_string << "load() ->\n"

  Rails.application.eager_load!
  models = ActiveRecord::Base.descendants
  models_size = models.size
  models.each_with_index do |model, model_index|
    t_name = model.table_name

    # model_mapping
    m_string << "    record_mapper:add_mapping({#{t_name}, record_info(fields, #{t_name})})"
    if model_index < models_size - 1
      m_string << ",\n"
    else
      m_string << ".\n"
    end

    # db_schema
    r_string << "-record(#{t_name}, {\n"
    size = model.attribute_names.size
    model.attribute_names.each_with_index do |field, index|
      r_string << "        #{field}"
      r_string << ",\n" if index < size - 1
    end
    r_string << "}).\n\n"
  end

  File.open("#{FRAMEWORK_ROOT_DIR}/game_server/include/db_schema.hrl", "w") do |io|
    io.write r_string
  end

  `mkdir -p #{FRAMEWORK_ROOT_DIR}/app/generates`
  File.open("#{FRAMEWORK_ROOT_DIR}/app/generates/model_mapping.erl", "w") do |io|
    io.write m_string
  end

  #Rails.env = old_env
end
