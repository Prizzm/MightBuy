desc "Reset & populate the database."
task :populate => ["db:drop", "db:migrate", "db:seed"]