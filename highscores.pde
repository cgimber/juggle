int addNewScore(String scoreString) {
  int scoreIndex = -1;
  for (int i=0; i<scores.length; i++) {
    println("scores[" + i + "] "  + scores[i]);
    if (score>=(Integer.parseInt(scores[i].substring(3, scores[i].length())))) {
      for (int j=scores.length-1; j>=max(i,1); j--) {
        scores[j] = scores[j-1];
      }
      scores[i] = scoreString;
      scoreIndex = i;
      break;
    }
  }
  return scoreIndex;
}