package entity

import "time"

type User struct {
	UserID       int64     `json:"user_id"`        // ユーザーID
	Name         string    `json:"name"`           // 名前
	Email        string    `json:"email"`          // Eメール
	FirebaseUID  string    `json:"firebase_uid"`   // firebase id
	Authority    string    `json:"authority"`      // 権限
	DeleteFlag   bool      `json:"delete_flag"`    // 削除フラグ
	UpdateUserID int64     `json:"update_user_id"` // 更新者
	Created      time.Time `json:"created"`        // 作成日時
	Updated      time.Time `json:"updated"`        // 更新日時
}
