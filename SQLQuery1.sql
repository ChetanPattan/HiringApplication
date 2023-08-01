create database ADOSkills
SELECT TOP (1000) [UserID]
      ,[FirstName]
      ,[LastName]
      ,[Email]
      ,[Username]
      ,[Password]
  FROM [ADOSkills].[dbo].[UserRegistration]

 --create procedure for insert registration

 use ADOSkills

create procedure spRegistration
@FirstName nvarchar(50),
@LastName nvarchar(50),
@Email nvarchar(50),
@Username nvarchar(50),
@Password nvarchar(50)
as
begin
insert into UserRegistration(FirstName, LastName, Email, Username, Password) values(@FirstName,@LastName,@Email,@Username,@Password)
end

exec spRegistration
'Chetan','Pattan','chetan0@abc.com','Chetan123','Chetan@123'

--procedure for checking username in table
create procedure spChkUsername
@Username nvarchar(50)
as
begin
select * from UserRegistration where Username = @Username;
end

exec spChkUsername @Username = 'Chetan123'

select * from UserRegistration

delete from UserRegistration where userid = 4

--create procedure for Login (retrieve hash password using username)
create procedure spLogin
@Username nvarchar(50)
as 
begin
select password from UserRegistration where Username=@Username
end

exec spLogin @username = 'User1'

drop table UserProfile
-- Create the table
CREATE TABLE [ADOSkills].[dbo].[UserDetails]
(
    [UserID] INT PRIMARY KEY,
    [FirstName] VARCHAR(50),
    [LastName] VARCHAR(50),
    [Email] VARCHAR(100),
    [DateOfBirth] DATE,
    [Contact] VARCHAR(12),
    [Qualification] VARCHAR(MAX),
    [Address] VARCHAR(MAX),
    [CollegeName] VARCHAR(MAX),
    [Experience] VARCHAR(50),
    FOREIGN KEY ([UserID]) REFERENCES [ADOSkills].[dbo].[UserRegistration] ([UserID])
);

alter table UserDetails add  Skills nvarchar(max);
drop table UserDetails

CREATE TABLE [ADOSkills].[dbo].[UserDetails]
(
	ID int primary key identity,
    [UserID] INT ,
    [FirstName] VARCHAR(50),
    [LastName] VARCHAR(50),
    [Email] VARCHAR(100),
    [DateOfBirth] DATE,
    [Contact] VARCHAR(12),
    [Qualification] VARCHAR(MAX),
    [Address] VARCHAR(MAX),
    [CollegeName] VARCHAR(MAX),
    [Experience] VARCHAR(50),
	Skills varchar(max),
	Position varchar(max)
    FOREIGN KEY ([UserID]) REFERENCES [ADOSkills].[dbo].[UserRegistration] ([UserID])
);

alter table UserDetails add  Position nvarchar(max);

 --procdure for getting UserId 
create procedure spUserId
 @Username nvarchar(50)
 as
 begin
 select UserID from UserRegistration where Username = @Username;
 end

 exec spUserId
 @Username = 'newuser123'


select * from UserDetails

--create procedure for inserting profile details
create procedure spInsertProfile
@UserID int,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@Email nvarchar(50),
@DateOfBirth date,
@Contact nvarchar(12),
@Qualification nvarchar(50),
@Address nvarchar(max),
@CollegeName nvarchar(max),
@Experience nvarchar(50),
@Skills nvarchar(max),
@Position nvarchar(max)
as
begin
insert into UserDetails(UserID,FirstName,LastName,Email,DateOfBirth,Contact,Qualification,Address,CollegeName,Experience,Skills,Position)
values(@UserID,@FirstName,@LastName,@Email,@DateOfBirth,@Contact,@Qualification,@Address,@CollegeName,@Experience,@Skills, @Position)
end

--create table for project details
create table UserProject
(
ID int Primary Key identity,
UserID int,
ProjectName varchar(50),
ProjectDesc varchar(max),
Foreign Key (UserID) References UserRegistration (UserID)
);

select * from UserProject
--Create procedure for inserting project details
create procedure spInsertProject
@UserID int,
@ProjectName nvarchar(50),
@ProjectDesc nvarchar(max)
as
begin
insert into UserProject (UserId, ProjectName, ProjectDesc) values(@UserID,@ProjectName,@ProjectDesc)
end

--create procedure for retrieving user details and to show that in card format
create procedure spUserInfo
as
begin
select UserID,FirstName, LastName, Qualification, Experience, Skills, Position from UserDetails
end

exec spUserInfo


--create procedure for user details in modal by using UserID
create procedure spCandidateDetails
@UserID int
as
begin
select ud.FirstName, ud.LastName,ud.Email,ud.DateOfBirth,ud.Contact,ud.Qualification, ud.Address,ud.CollegeName,ud.Experience,ud.Skills,ud.Position,
up.ProjectName,up.ProjectDesc from UserDetails as ud inner join UserProject as up on ud.UserID = up.UserID 
where ud.UserID = @UserID;
end


exec spCandidateDetails
@UserID = 1

--create table ConnectCandidate
create table ConnectCandidate
(
ID int Primary Key identity,
UserID int,
FullName varchar(50),
Email varchar(max),
Contact varchar(12),
Comments varchar(max),
Foreign Key (UserID) References UserRegistration (UserID)
);

--create procedure for inserting comments to candidate
create procedure spConnectCandidate
@UserID int,
@FullName varchar(100),
@Email varchar(50),
@Contact varchar(15),
@Comments varchar(max)
as
begin
insert into ConnectCandidate (UserID, FullName,Email,Contact,Comments) values(@UserID, @FullName, @Email,@Contact, @Comments)
end

select * from ConnectCandidate

--create procedure for retrieving project details
create procedure spProjectsList
@UserID int
as
begin
select ID, ProjectName, ProjectDesc from UserProject where UserID = @UserID
end

exec spProjectsList
@UserID=1

--procedure for updating project details
CREATE PROCEDURE spUpdateProject
@UserID int,
    @ProjectName varchar(50),
    @ProjectDesc varchar(max)
AS
BEGIN
    UPDATE UserProject
    SET ProjectName = @ProjectName,
        ProjectDesc = @ProjectDesc
    WHERE UserID = @UserID
END

--procedure for deleting project details
alter procedure spDeleteProject
@UserID int,
@ID int
as
begin
delete  from UserProject where ID= @ID
end

exec spDeleteProject
@UserID = 2,
@ID = 1

--create procedure for retrieving user details by userid
create procedure spUserProfile
@UserID int
as 
begin
select FirstName, LastName, Email, DateOfBirth, Contact, Qualification, Address, CollegeName, Experience, Skills, Position from UserDetails where UserID = @UserID
end

exec spUserProfile
@UserID =1

ALTER TABLE UserDetails
ALTER COLUMN DateOfBirth DATE;