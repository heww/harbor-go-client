// Code generated by go-swagger; DO NOT EDIT.

package models

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"context"

	"github.com/go-openapi/strfmt"
	"github.com/go-openapi/swag"
)

// RetentionPolicyScope retention policy scope
//
// swagger:model RetentionPolicyScope
type RetentionPolicyScope struct {

	// level
	Level string `json:"level,omitempty"`

	// ref
	Ref int64 `json:"ref,omitempty"`
}

// Validate validates this retention policy scope
func (m *RetentionPolicyScope) Validate(formats strfmt.Registry) error {
	return nil
}

// ContextValidate validates this retention policy scope based on context it is used
func (m *RetentionPolicyScope) ContextValidate(ctx context.Context, formats strfmt.Registry) error {
	return nil
}

// MarshalBinary interface implementation
func (m *RetentionPolicyScope) MarshalBinary() ([]byte, error) {
	if m == nil {
		return nil, nil
	}
	return swag.WriteJSON(m)
}

// UnmarshalBinary interface implementation
func (m *RetentionPolicyScope) UnmarshalBinary(b []byte) error {
	var res RetentionPolicyScope
	if err := swag.ReadJSON(b, &res); err != nil {
		return err
	}
	*m = res
	return nil
}