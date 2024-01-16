package api

import (
	"database/sql"
	"fmt"
	"net/http"

	db "github.com/Rishi-Mishra0704/backend_course/db/sqlc"
	"github.com/gin-gonic/gin"
)

type TransferRequest struct {
	FromAccountId int64  `json:"from_account_id" binding:"required,min=1"`
	ToAccountId   int64  `json:"to_account_id" binding:"required,min=1"`
	Amount        int64  `json:"amount" binding:"required,gt=0"`
	Currency      string `json:"currency" binding:"required,currency"`
}

func (server *Server) createTransfer(ctx *gin.Context) {
	var request TransferRequest
	if err := ctx.ShouldBindJSON(&request); err != nil {
		ctx.JSON(http.StatusBadRequest, errorResponse(err))
		return
	}

	if !server.validAcc(ctx, request.FromAccountId, request.Currency) {
		return
	}

	if !server.validAcc(ctx, request.ToAccountId, request.Currency) {
		return
	}

	arg := db.TransferTxParams{
		FromAccountID: request.FromAccountId,
		ToAccountID:   request.ToAccountId,
		Amount:        request.Amount,
	}

	result, err := server.store.TransferTx(ctx, arg)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return
	}
	ctx.JSON(http.StatusOK, result)
}

func (server *Server) validAcc(ctx *gin.Context, accountID int64, currency string) bool {
	account, err := server.store.GetAccount(ctx, accountID)

	if err != nil {
		if err == sql.ErrNoRows {
			ctx.JSON(http.StatusNotFound, errorResponse(err))
			return false
		}
		ctx.JSON(http.StatusInternalServerError, errorResponse(err))
		return false
	}

	if account.Currency != currency {
		fmt.Printf("Account %d currency mismatch %s vs %s", accountID, account.Currency, currency)
		ctx.JSON(http.StatusBadRequest, errorResponse(fmt.Errorf("account currency mismatch")))
		return false
	}

	return true
}
