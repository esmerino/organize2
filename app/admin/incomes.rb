ActiveAdmin.register Income do
  extend PaginateByMonth
  extend ConfirmableResource

  menu priority: 2

  decorate_with IncomeDecorator

  config.paginate = false

  filter :description
  filter :confirmed
  filter :date
  filter :category
  filter :transaction_hash

  permit_params :description, :value, :date, :category, :chargeable_type,
    :chargeable_id, :drive_id, :transaction_hash

  action_item :duplicate, only: :show do
    link_to "Duplicate", new_admin_income_path(income: income.duplicable_attributes)
  end

  sidebar "Account/Card", only: :show do
    para "#{resource.class.human_attribute_name(:name)}: #{resource.chargeable.to_s}"

    case resource.chargeable
    when Account
      para "#{resource.chargeable.class.human_attribute_name(:balance)}: #{resource.chargeable.balance}"
    when Card
      para "#{resource.chargeable.class.human_attribute_name(:payment_day)}: #{resource.chargeable.payment_day}"
    end
  end

  index do
    selectable_column

    id_column

    column :confirmed
    column :description
    column :value
    column :chargeable
    column :date

    actions
  end

  show do
    attributes_table do
      row :confirmed
      row :description do |income|
        income.object.description
      end
      row :category
      row :date
      row :chargeable
      row :value
      row :drive_id
      row :transaction_hash
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  form do |f|
    inputs t("active_admin.details", model: Income) do
      input :description, input_html: { autofocus: true }
      input :date, as: :string, input_html: { value: (f.object.date || Date.current) }
      input :category
      input :chargeable_type, as: :hidden, input_html: { value: "Account", disabled: income.confirmed? }
      input :chargeable_id, collection: Account.active.ordered, as: :select, input_html: { disabled: income.confirmed? }
      input :value, input_html: { disabled: income.confirmed? }
      input :transaction_hash
    end

    actions
  end
end
