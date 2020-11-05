# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(title: movie[:title], rating: movie[:rating], release_date: movie[:release_date])
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  if page.body.index(e1).nil?
      fail "bro"
  end
  if page.body.index(e2).nil?
      fail "broski"
  end
  if page.body.index(e1) > page.body.index(e2)
      fail "why"
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  # all_cb = ["ratings_G", "ratings_PG", "ratings_PG-13", "ratings_R"]
  cb = rating_list.split /\s*,\s*/
  cb = cb.map {|r| "ratings_".concat(r)}
  # not_cb = all_cb.select {|r| not (cb.include? r)}
  cb.each do |r|
      if uncheck
          uncheck(r)
      else
          check(r)
      end
  end
  # not_cb.each do |r|
  #     uncheck(r)
  # end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  Movie.all.each do |m|
      if page.respond_to? :should
        page.should have_content(m.title)
      else
        assert page.has_content?(m.title)
      end
  end
end
