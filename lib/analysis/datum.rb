require_relative './users.rb'

$datum = {
  # 1日目

  my_system0: {
    father: {
      questionnaires: {
        before: {
          attribute: $users[:father].questionnaire.find(35),
          interest: $users[:father].questionnaire.find(36),
          self_efficacy: $users[:father].questionnaire.find(37),
        },
        after: {
          motivation: $users[:father].questionnaire.find(38),
        }
      },
    
      train: $users[:father].train_records.find(60),

      test: $users[:father].train_records.find(63)
    },
    
    daughter: {
      questionnaires: {
        before: {
          attribute: $users[:daughter].questionnaire.find(31),
          interest: $users[:daughter].questionnaire.find(32),
          self_efficacy: $users[:daughter].questionnaire.find(33),
        },
        after: {
          motivation: $users[:daughter].questionnaire.find(34),
        }
      },
    
      train: $users[:daughter].train_records.find(59),

      test: $users[:daughter].train_records.find(61)
    },
  },

  shimamura0: {
    mother: {
      questionnaires: {
        before: {
          attribute: $users[:mother].questionnaire.find(40),
          interest: $users[:mother].questionnaire.find(41),
          self_efficacy: $users[:mother].questionnaire.find(42),
        },
        after: {
          motivation: $users[:mother].questionnaire.find(43),
        }
      },

      # test: $users[:mother].train_records.find(62)
      test: User.find_by(user_name: "panda").train_records.find(64)
    },
  },


  # 1日目

  my_system1: {
    father: {
      questionnaires: {
        after: {
          motivation: $users[:father].questionnaire.find(48),
        }
      },

      train: $users[:father].train_records.find(66),
      
      test: $users[:father].train_records.find(68),
    },

    daughter: {
      questionnaires: {
        after: {
          motivation: $users[:daughter].questionnaire.find(47),
        }
      },

      train: $users[:daughter].train_records.find(65),
      
      test: $users[:daughter].train_records.find(67),
    },
  },

  shimamura1: {
    mother: {
      questionnaires: {
        after: {
          motivation: $users[:mother].questionnaire.find(49),
        }
      },

      test: $users[:mother].train_records.find(69),
    }
  }
}
