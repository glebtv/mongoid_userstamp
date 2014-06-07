# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Mongoid::Userstamp do
  subject { Book.new(name: 'Crafting Rails Applications') }
  let(:user_1) { User.create!(name: 'Charles Dikkens') }
  let(:user_2) { User.create!(name: 'Edmund Wells') }

  it { is_expected.to respond_to :creator_id }
  it { is_expected.to respond_to :creator }
  it { is_expected.to respond_to :updater_id }
  it { is_expected.to respond_to :updater }

  describe '#current_user' do
    subject{ Mongoid::Userstamp.current_user }

    context 'when current user is not set' do
      before { User.current = nil }
      it { is_expected.to be_nil }
    end

    context 'when current user is set' do
      before{ User.current = user_1 }
      it { is_expected.to eq user_1 }
    end
  end

  context 'when created without a user' do
    before do
      User.current = nil
      subject.save!
    end

    it { expect(subject.creator_id).to be_nil }
    it { expect(subject.creator).to be_nil }
    it { expect(subject.updater_id).to be_nil }
    it { expect(subject.updater).to be_nil }
  end

  context 'when creator is manually set' do
    before{ User.current = user_1 }

    context 'set by id' do
      before do
        subject.creator_id = user_2._id
        subject.save!
      end

      it 'should not be overridden when saved' do
        expect(subject.creator_id).to eq user_2.id
        expect(subject.creator).to eq user_2
        expect(subject.updater_id).to eq user_1.id
        expect(subject.updater).to eq user_1
      end
    end
    context 'set by model' do
      before do
        subject.creator = user_2
        subject.save!
      end
      
      it 'should not be overridden when saved' do
        expect(subject.creator_id).to eq user_2.id
        expect(subject.creator).to eq user_2
        expect(subject.updater_id).to eq user_1.id
        expect(subject.updater).to eq user_1
      end
    end
  end

  context 'when created by a user' do
    before do
      User.current = user_1
      subject.save!
    end

    it { expect(subject.creator_id).to eq(user_1.id) }
    it { expect(subject.creator).to eq(user_1) }
    it { expect(subject.updater_id).to eq(user_1.id) }
    it { expect(subject.updater).to eq(user_1) }

    context 'when updated by a user' do
      before do
        User.current = user_2
        subject.save!
      end

      it { expect(subject.creator_id).to eq(user_1.id) }
      it { expect(subject.creator).to eq(user_1) }
      it { expect(subject.updater_id).to eq(user_2.id) }
      it { expect(subject.updater).to eq(user_2) }
    end

    context 'when user has been destroyed' do
      before do
        User.current = user_2
        subject.save!
        user_1.destroy
        user_2.destroy
        subject.reload
      end

      it { expect(subject.creator_id).to eq(user_1.id) }
      it { expect(subject.creator).to eq(nil) }
      it { expect(subject.updater_id).to eq(user_2.id) }
      it { expect(subject.updater).to eq(nil) }
    end
  end

  describe '#config' do
    before :all do
      Mongoid::Userstamp.config do |c|
        c.user_reader = :current_user
        c.user_model  = :user

        c.creator_field   = :c_by
        c.updater_field   = :u_by
      end

      # class definition must come after config
      class Novel
        include Mongoid::Document
        include Mongoid::Userstamp

        field :name
      end
    end
    after :all do
      Mongoid::Userstamp.config.reset!
    end
    subject { Novel.new(name: 'Ethyl the Aardvark goes Quantity Surveying') }

    context 'when created by a user' do
      before do
        User.current = user_1
        subject.save!
      end

      it { expect(subject.c_by_id).to eq(user_1.id) }
      it { expect(subject.c_by).to eq(user_1) }
      it { expect(subject.u_by_id).to eq(user_1.id) }
      it { expect(subject.u_by).to eq(user_1) }

      context 'when updated by a user' do
        before do
          User.current = user_2
          subject.save!
        end

        it { expect(subject.c_by_id).to eq(user_1.id) }
        it { expect(subject.c_by).to eq(user_1) }
        it { expect(subject.u_by_id).to eq(user_2.id) }
        it { expect(subject.u_by).to eq(user_2) }
      end
    end
  end

end
