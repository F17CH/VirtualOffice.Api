IO.puts("Adding a couple of users...")

VirtualOffice.Account.create_user(%{email: "user1@email.com", password: "qwerty"})
VirtualOffice.Account.create_user(%{email: "user2@email.com", password: "asdfgh"})
