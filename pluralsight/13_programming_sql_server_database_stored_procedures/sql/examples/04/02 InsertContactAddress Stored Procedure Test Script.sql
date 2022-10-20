USE Contacts;

EXEC dbo.InsertContactAddress
	@ContactId = 24,
	@HouseNumber = '10',
	@Street = 'Downing Street',
	@City = 'London',
	@Postcode = 'SW1 2AA';