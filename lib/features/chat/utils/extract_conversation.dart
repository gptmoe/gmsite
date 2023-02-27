String extractConversation(String conversation) {
  return """
    Read the following conversation and extract principles about the user from it. 
    What are some common themes, facts, preferences, personal information, or observations about the user.
    List out the principles and write them in very very brief sentences, also add 3 tags (1 word tag at maximum) for each principle,
    the tags is lowercased
    and then map each principles with the tag in this JSON format:
    {
      "principles": [
        "tags": ["friendly", "persuasive", "personality"],
        "text": "hi"
      ]
    }
    CONVERSATION
    $conversation
    Copyable JSON format with tags for each principles (make sure can the JSON format is valid):
    """;
}
