class Prompts {
  static final List<Map<String, dynamic>> prompts = [
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate names for my character based on my {class} and {race}''',
      'prompt':
          'Generate name for my character based on my {class} and {race}. Show me why you think this name is good, and from which culture or word it comes from.',
      'outputFieldName': 'name',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate names for my character based on my {class} and {race}''',
      'prompt':
          'Generate 10 names for my character based on my {class} and {race}. In textMessage give me response where you list all of names with their origin.',
      'outputFieldName': 'name',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate an image of my character based on my class: {class}, races: {race}''',
      'prompt':
          '''Generate an image of my character based on my class: {class}, races: {race}''',
      'outputFieldName': 'images',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate an image of my character based on my class: {class}, races: {race}''',
      'prompt':
          '''Create a sketch portrait of a {class} {race}, looking straightforward and directly at the viewer, with a neutral, calm, and composed expression. The character should have prominent accessories such as {describe accessories}, and the shoulders and chest should be included for a more full-body feel. The overall mood should reflect the character’s class and race, with high contrast and highly detailed features. Use sharp, defined lines for the features, and maintain a mature or middle-aged appearance. The artwork should have minimal brushstrokes, keeping the lines neat and simple, resembling a digital sketch or vector art style. The character should be depicted in monochromatic black, with varying shades of one color for contrast. The background should be white, with the character fully visible within the frame—make sure the entire portrait, including the head, shoulders, and chest, is included and not cropped. The lighting should be even, with no strong shadows, and the character should be centered with breathing space around them. Centered Composition. Medium Shot''',
      'outputFieldName': 'images',
    },
  ];
}
