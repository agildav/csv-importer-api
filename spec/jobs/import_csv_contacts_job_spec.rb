require 'rails_helper'

RSpec.describe ImportCsvContactsJob, type: :job do
  let(:uploaded_file) { create(:uploaded_file, :with_attachment) }
  let(:user) { uploaded_file.user }
  let(:params) {
    {
      address: "address",
      birth_date: "birth_date",
      credit_card: "credit_card",
      email: "email",
      name: "name",
      phone: "phone"
    }
  }
  let(:arguments) { [user.id, params, uploaded_file, nil] }
  subject(:job) { described_class.perform_later(*arguments) }

  it 'queues the job' do
    expect { job }.to have_enqueued_job(described_class)
      .with(*arguments)
      .on_queue("default")
  end
end
