defmodule GraphqlParserTest do
  use ExUnit.Case

  def tokenize(string) do
    {:ok, tokens, _} = :graphql_lexer.string(string)
    tokens
  end

  def assert_parse(input_string, expected_tokens) do
    {:ok, parse_result} = :graphql_parser.parse(tokenize(input_string))
    assert parse_result == expected_tokens
  end

  test "simple selection set" do
    assert_parse '{ hero }', [
      {[ 'hero' ]}
    ]
  end

  test "aliased selection set" do
    assert_parse '{ alias: hero }', [
      {[ {'alias', 'hero'} ]}
    ]
  end

  test "multiple selection set" do
    assert_parse '{ id firstName lastName }', [
      { ['id', 'firstName', 'lastName'] }
    ]
  end

  test "nested selection set" do
    assert_parse '{ me { name } }', [
      { [{ 'me', {['name']} }] }
    ]
  end

  test "named query with nested selection set" do
    assert_parse 'query myQuery { user { name } }', [
      { :query, 'myQuery', {[
        { 'user', {['name']} }
      ]}
    }]
  end

  test "named mutation with nested selection set" do
    assert_parse 'mutation myMutation { user { name } }', [
      { :mutation, 'myMutation', {[
        { 'user', {['name']} }
      ]}
    }]
  end

  test "nested selection set with arguments" do
    assert_parse '{ user(id: 4) { name ( thing : "abc" ) } }', [{[
      {'user', [{'id', 4}], {
        [{'name', [{'thing', '"abc"'}]}]}
      }]}
    ]
  end

  test "aliased nested selection set with arguments" do
    assert_parse '{ alias: user(id: 4) { alias2 : name ( thing : "abc" ) } }', [{[
        {'alias', 'user', [{'id', 4}], {
          [{'alias2', 'name', [{'thing', '"abc"'}]}]}}]}
    ]
  end

  test "FragmentSpread" do
    assert_parse 'query myQuery { ...fragSpread }', [{
      :query, 'myQuery', {[ 'fragSpread' ]}
    }]
  end

  test "FragmentSpread with no argument Directive" do
    assert_parse 'query myQuery { ...fragSpread @include }', [{
      :query, 'myQuery', {[
        {:'...', 'fragSpread', [@: 'include']}
      ]}
    }]
  end

  test "FragmentSpread with Directives" do
    assert_parse 'query myQuery { ...fragSpread @directive(num: 1.23) }', [{
      :query, 'myQuery', {[
        {:'...', 'fragSpread', [{ :'@', 'directive', [{'num', 1.23}] }] }
      ]}
    }]
  end

end