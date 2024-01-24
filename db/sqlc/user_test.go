package db

import (
	"context"
	"testing"
	"time"

	"github.com/Rishi-Mishra0704/backend_course/util"
	"github.com/stretchr/testify/require"
)

func createRandomUser(t *testing.T) User {
	hashedPassword, err := util.HashPassword(util.RandomString(6))
	require.NoError(t, err)
	arg := CreateUserParams{
		Username:       util.RandomOwner(),
		Email:          util.RandomEmail(),
		HashedPassword: hashedPassword,
		FullName:       util.RandomOwner(),
	}

	user, err := testQueries.CreateUser(context.Background(), arg)
	require.NoError(t, err)
	require.NotEmpty(t, user)

	require.Equal(t, arg.Username, user.Username)
	require.Equal(t, arg.Email, user.Email)
	require.Equal(t, arg.FullName, user.FullName)

	require.True(t, user.PasswordChangedAt.Time.IsZero())
	require.NotZero(t, user.CreatedAt)

	return user
}
func TestCreateuser(t *testing.T) {
	createRandomUser(t)
}

func TestGetusers(t *testing.T) {
	user1 := createRandomUser(t)
	user2, err := testQueries.GetUser(context.Background(), user1.Username)
	// Convert pgtype.Timestamp to time.Time
	createdAt1 := user1.CreatedAt.Time
	createdAt2 := user2.CreatedAt.Time

	passChangedAt1 := user1.PasswordChangedAt.Time
	passChangedAt2 := user2.PasswordChangedAt.Time

	require.NoError(t, err)
	require.NotEmpty(t, user2)

	require.Equal(t, user1.Username, user2.Username)
	require.Equal(t, user1.HashedPassword, user2.HashedPassword)
	require.Equal(t, user1.FullName, user2.FullName)
	require.Equal(t, user1.Email, user2.Email)
	require.WithinDuration(t, createdAt1, createdAt2, time.Second)
	require.WithinDuration(t, passChangedAt1, passChangedAt2, time.Second)
}
