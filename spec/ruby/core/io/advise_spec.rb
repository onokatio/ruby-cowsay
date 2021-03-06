# -*- encoding: utf-8 -*-
require_relative '../../spec_helper'
require_relative 'fixtures/classes'

describe "IO#advise" do
  before :each do
    @io = IOSpecs.io_fixture "lines.txt"
  end

  after :each do
    @io.close unless @io.closed?
  end

  it "raises a TypeError if advise is not a Symbol" do
    -> {
      @io.advise("normal")
    }.should raise_error(TypeError)
  end

  it "raises a TypeError if offset cannot be coerced to an Integer" do
    -> {
      @io.advise(:normal, "wat")
    }.should raise_error(TypeError)
  end

  it "raises a TypeError if len cannot be coerced to an Integer" do
    -> {
      @io.advise(:normal, 0, "wat")
    }.should raise_error(TypeError)
  end

  it "raises a RangeError if offset is too big" do
    -> {
      @io.advise(:normal, 10 ** 32)
    }.should raise_error(RangeError)
  end

  it "raises a RangeError if len is too big" do
    -> {
      @io.advise(:normal, 0, 10 ** 32)
    }.should raise_error(RangeError)
  end

  it "raises a NotImplementedError if advise is not recognized" do
    ->{
      @io.advise(:foo)
    }.should raise_error(NotImplementedError)
  end

  it "supports the normal advice type" do
    @io.advise(:normal).should be_nil
  end

  it "supports the sequential advice type" do
    @io.advise(:sequential).should be_nil
  end

  it "supports the random advice type" do
    @io.advise(:random).should be_nil
  end

  it "supports the dontneed advice type" do
    @io.advise(:dontneed).should be_nil
  end

  it "supports the noreuse advice type" do
    @io.advise(:noreuse).should be_nil
  end

  platform_is_not :linux do
    it "supports the willneed advice type" do
      @io.advise(:willneed).should be_nil
    end
  end

  guard -> { platform_is :linux and kernel_version_is '3.6' } do # [ruby-core:65355] tmpfs is not supported
    it "supports the willneed advice type" do
      @io.advise(:willneed).should be_nil
    end
  end

  it "raises an IOError if the stream is closed" do
    @io.close
    -> { @io.advise(:normal) }.should raise_error(IOError)
  end
end
