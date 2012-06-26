@user = User.new(:email => 'clairton.rodrigo@gmail.com',:password => '123456')
@user.save

@sum = Sum.create(:id => 1, :value => 0.00)
@sum.save
