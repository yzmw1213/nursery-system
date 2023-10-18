package entity

import "time"

type NurseryFacility struct {
	NurseryFacilityID int64     `json:"nursery_facility_id"` // 保育施設ID
	Name              string    `json:"name"`                // 名前
	DeleteFlag        bool      `json:"delete_flag"`         // 削除フラグ
	UpdateUserID      int64     `json:"update_user_id"`      // 更新者
	Created           time.Time `json:"created"`             // 作成日時
	Updated           time.Time `json:"updated"`             // 更新日時
}
