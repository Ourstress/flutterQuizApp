const Map<String, dynamic> config = {
  'cardMaxWidth': 200.0,
  'scaleHeaders': [
    {1: 'Strongly disagree'},
    {2: 'Disagree'},
    {3: 'Neutral'},
    {4: 'Agree'},
    {5: 'Strongly agree'}
  ],
  'mockQuiz': [
    {
      'quizTitle': 'maths 101',
      'questions': [
        {'title': 'Do you like Algebra?'}
      ]
    },
    {
      'quizTitle': 'Leadership Communication Style',
      'questions': [
        {
          'title':
              'A leader should have self direction without input from followers',
          'type': 'authoritarian'
        },
        {
          'title':
              'A leader should set direction with input and consultation with followers',
          'type': 'democratic'
        },
        {
          'title':
              'A leader should set direction based on the wishes of followers',
          'type': 'laissezFaire'
        },
        {
          'title':
              'A leader should use a task force of committee rather than making a decision alone',
          'type': 'democratic'
        },
        {
          'title':
              'A leader should evaluate the progress of work with little input from followers',
          'type': 'authoritarian'
        },
        {
          'title':
              'A leader should leave it up to followers to initiate informal, day-to-day communication',
          'type': 'laissezFaire'
        },
        {
          'title':
              'A leader should encourage followers to initiate decision making without first seeking approval',
          'type': 'laissezFaire'
        },
        {
          'title':
              'A leader should closely monitor rules and regulation - punishing those who break the rules',
          'type': 'authoritarian'
        },
        {
          'title':
              'A leader should keep followers up to date on issues affecting the work group',
          'type': 'democratic'
        },
        {
          'title':
              'A leader should explain the reasons for making a decision to his/her followers',
          'type': 'democratic'
        },
        {
          'title':
              'A leader should remain aloof and not get too friendly with his/her followers',
          'type': 'authoritarian'
        },
        {
          'title':
              'A leader should provide broad goals and leave decisions regarding the methods for achieving the goals to followers',
          'type': 'laissezFaire'
        }
      ]
    }
  ]
};
