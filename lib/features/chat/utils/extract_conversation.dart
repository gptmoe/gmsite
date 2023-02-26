String extractConversation(String conversation) {
  return """
    Read the following conversation and extract principles about the user from it. 
    What are some common themes, facts, preferences, personal information, or observations about the user.
    List out the principles and write them in very very brief sentences, also add 3 tags for each principle,
    for the tags, use maximum 2 word with underscore and lowercased
    and then map each principles with the tag in this JSON format:
    {
      "principles": [
        "tags": ["tag_1", "tag_2", "tag_3" ...],
        "text": "hi"
      ]
    }
    CONVERSATION (in reverse):
    $conversation
    Copyable JSON format with tags for each principles (make sure can the JSON format is valid):
    """;
}
