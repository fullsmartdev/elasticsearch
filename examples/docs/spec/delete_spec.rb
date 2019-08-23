# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require_relative 'spec_helper'

describe 'Delete documentation examples' do
  let(:client) do
    DEFAULT_CLIENT
  end

  before do
    client.indices.create(index: 'twitter')
    client.index(index: 'twitter', id: 1, body: {})
  end

  after do
    client.indices.delete(index: 'twitter')
  end

  it 'executes the example code: - c5e5873783246c7b1c01d8464fed72c4' do
    # tag::c5e5873783246c7b1c01d8464fed72c4[]
    response = client.delete(index: 'twitter', id: 1)
    # end::c5e5873783246c7b1c01d8464fed72c4[]

    puts '-'*50
    puts response
    puts '-'*50
  end

  it 'executes the example code: - 47b5ff897f26e9c943cee5c06034181d' do
    # tag::47b5ff897f26e9c943cee5c06034181d[]
    response = client.delete(index: 'twitter', id: 1, routing: 'kimchy')
    # end::47b5ff897f26e9c943cee5c06034181d[]

    puts '-'*50
    puts response
    puts '-'*50
  end

  it 'executes the example code: - d90a84a24a407731dfc1929ac8327746' do
    # tag::d90a84a24a407731dfc1929ac8327746[]
    response = client.delete(index: 'twitter', id: 1, routing: 'kimchy', timeout: '5m')
    # end::d90a84a24a407731dfc1929ac8327746[]

    puts '-'*50
    puts response
    puts '-'*50
  end
end
