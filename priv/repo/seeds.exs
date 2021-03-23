IO.puts("Adding a couple of users...")

VirtualOffice.Account.create_user(%{email: "user1@email.com", password: "qwerty", password_confirmation: "qwerty", first_name: "Johnny", last_name: "Test"})
VirtualOffice.Account.create_user(%{email: "user2@email.com", password: "asdfgh", password_confirmation: "asdfgh", first_name: "Alice", last_name: "Test"})
