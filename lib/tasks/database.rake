namespace :db do
  desc "Drop, create, migrate and seed database"
  task rebuild: :environment do
    puts "== db:drop =="
    Rake::Task["db:drop"].invoke

    puts "== db:create =="
    Rake::Task["db:create"].invoke

    puts "== db:migrate =="
    Rake::Task["db:migrate"].invoke

    puts "== db:seed =="
    Rake::Task["db:seed"].invoke

    puts "✅ db:rebuild done"
  end
end