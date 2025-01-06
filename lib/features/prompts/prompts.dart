class Prompts {
  static final List<Map<String, dynamic>> prompts = [
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate name of my Character based on class and race''',
      'prompt':
          'Generate me 10 names for my character based on my {class} and {race}. In textMessage give me response wher      e you list all of names with their origin.',
      'outputFieldName': 'name',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['class', 'race'],
      'displayedPrompt':
          '''Generate picture of my Character based on Class And Race''',
      'prompt':
          '''Create a sketch portrait of a {class} {race}, looking straightforward and directly at the viewer, with a neutral, calm, and composed expression. The character should have prominent accessories such as describe accessories, and the shoulders and chest should be included for a more full-body feel. The overall mood should reflect the character's class and race, with high contrast and highly detailed features. Use sharp, defined lines for the features, and maintain a mature or middle-aged appearance. The artwork should have minimal brushstrokes, keeping the lines neat and simple, resembling a digital sketch or vector art style. The character should be depicted in monochromatic black, with varying shades of one color for contrast. The background should be white, with the character fully visible within the frame—make sure the entire portrait, including the head, shoulders, and chest, is included and not cropped. The lighting should be even, with no strong shadows, and the character should be centered with breathing space around them. Centered Composition. Medium Shot''',
      'outputFieldName': 'images',
    },
    {
      'documentType': 'character',
      'requiredFieldNames': ['swallow'],
      'displayedPrompt':
          '''Are you suggesting coconuts migrate? Not at all! They could be carried.''',
      'prompt':
          '''Create a simplified flat vector graphic of two swallows in flight. The swallows must be holding a coconut by a string. Swallows have string in beaks and coconut is wrapped with that taut. The birds' wings should be outstretched in an elegant pose. Use a minimalistic style with clean geometric shapes, no shading, and deep, muted colors like blues, browns, and blacks. The background should remain plain white, and the focus must stay on the swallows and the coconut.''',
      'outputFieldName': 'images',
    }
  ];
}
