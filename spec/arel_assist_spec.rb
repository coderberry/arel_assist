# frozen_string_literal: true

RSpec.describe ArelAssist do
  it "has a version number" do
    expect(ArelAssist::VERSION).not_to be(nil)
  end

  describe "#arel_count" do
    it "generates SQL" do
      query = subject.arel_count(Post.arel_table[:id])

      expect(query).to be_a(Arel::Nodes::NamedFunction)
      expect(query.to_sql).to eq('COUNT("posts"."id")')
      expect(query.as("count").to_sql).to eq(
        'COUNT("posts"."id") AS count'
      )
    end
  end

  describe "#arel_date_trunc" do
    it "generates SQL" do
      query = subject.arel_date_trunc("day", Post.arel_table[:created_at])

      expect(query).to be_a(Arel::Nodes::NamedFunction)
      expect(query.to_sql).to eq("date_trunc('day', \"posts\".\"created_at\")")
      expect(query.as("date_posted").to_sql).to eq(
        "date_trunc('day', \"posts\".\"created_at\") AS date_posted"
      )
    end
  end

  describe "#arel_max" do
    it "generates SQL" do
      query = subject.arel_max(Post.arel_table[:created_at])

      expect(query).to be_a(Arel::Nodes::NamedFunction)
      expect(query.to_sql).to eq('MAX("posts"."created_at")')
      expect(query.as("last_post_created_at").to_sql).to eq(
        'MAX("posts"."created_at") AS last_post_created_at'
      )
    end
  end

  describe "#arel_min" do
    it "generates SQL" do
      query = subject.arel_min(Post.arel_table[:created_at])

      expect(query).to be_a(Arel::Nodes::NamedFunction)
      expect(query.to_sql).to eq('MIN("posts"."created_at")')
      expect(query.as("first_post_created_at").to_sql).to eq(
        'MIN("posts"."created_at") AS first_post_created_at'
      )
    end
  end

  describe "#sqlv" do
    context "with an ActiveRecord::Relation" do
      it "returns the sql string" do
        query = Post.all
        expect(subject.sqlv(query)).to eq(query.to_sql)
      end
    end

    context "with an Arel::Attributes::Attribute" do
      it "returns the sql string" do
        query = Post.arel_table[:id]
        expect(subject.sqlv(query)).to eq('"posts"."id"')
      end
    end

    context "with an Array of string" do
      it "returns the sql string" do
        expect(subject.sqlv(%w[foo bar])).to eq("ARRAY['foo','bar']")
      end
    end

    context "with an Array of assorted objects" do
      it "returns the sql string" do
        expect(subject.sqlv(["foo", 0, true])).to eq("ARRAY['foo',0,true]")
      end
    end

    context "with a Range" do
      it "returns the sql string" do
        expect(subject.sqlv((1..10))).to eq("ARRAY[1,2,3,4,5,6,7,8,9,10]")
      end
    end

    context "with a Time object" do
      it "returns the sql string" do
        t = Time.parse("2022-09-30 17:15:00 UTC")
        result = subject.sqlv(t)
        expect(result).to be_a(Arel::Nodes::Quoted)
        expect(result.to_sql).to eq("'2022-09-30 17:15:00'")
      end
    end

    context "with a DateTime object" do
      it "returns the sql string" do
        dt = DateTime.parse("2022-09-30 17:15:00 UTC")
        result = subject.sqlv(dt)
        expect(result).to be_a(Arel::Nodes::Quoted)
        expect(result.to_sql).to eq("'2022-09-30 17:15:00'")
      end
    end

    context "with a Date object" do
      it "returns the sql string" do
        d = Date.parse("2022-09-30")
        result = subject.sqlv(d)
        expect(result).to be_a(Arel::Nodes::Quoted)
        expect(result.to_sql).to eq("'2022-09-30'")
      end
    end

    context "with a String" do
      it "returns the sql string" do
        result = subject.sqlv("foo")
        expect(result).to be_a(Arel::Nodes::Quoted)
        expect(result.to_sql).to eq("'foo'")
      end
    end
  end
end
