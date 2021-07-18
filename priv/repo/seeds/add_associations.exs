IO.puts("Adding associations")

#VirtualOffice.Account.create_user(%{email: "user1@email.com", password: "qwerty", password_confirmation: "qwerty", first_name: "Johnny", last_name: "Test"})
#VirtualOffice.Account.create_user(%{email: "user3@email.com", password: "asdfgh", password_confirmation: "asdfgh", first_name: "David", last_name: "Test"})

VirtualOffice.Group.create_association(%{name: "Test Business"})




#vI.create_user(%{email: "user3@email.com", password: "asdfgh", password_confirmation: "asdfgh", first_name: "David", last_name: "Test"})
