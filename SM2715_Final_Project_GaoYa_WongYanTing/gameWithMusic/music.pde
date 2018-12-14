import arb.soundcipher.*;
import arb.soundcipher.constants.*;

SoundCipher sc = new SoundCipher(this);
SoundCipher sc2 = new SoundCipher(this);
SoundCipher sc3 = new SoundCipher(this);
SoundCipher sc4 = new SoundCipher(this);
SoundCipher sc5 = new SoundCipher(this);

boolean canPlay = false;

int noteCounter = 0;

int[][] note = { {48, 0, 0, 0, 0}, 
  {48, 52, 0, 0, 0}, 
  {48, 55, 0, 0, 0}, 
  {48, 60, 0, 0, 0}, 

  {43, 0, 0, 0, 0}, 
  {43, 50, 0, 0, 0}, 
  {43, 55, 0, 0, 0}, 
  {43, 59, 0, 0, 0}, 

  {45, 0, 0, 0, 0}, 
  {45, 48, 0, 0, 0}, 
  {45, 52, 0, 0, 0}, 
  {45, 57, 0, 0, 0}, 

  {40, 0, 0, 0, 0}, 
  {40, 47, 0, 0, 0}, 
  {40, 52, 0, 0, 0}, 
  {40, 55, 0, 0, 0}, 

  {41, 0, 0, 0, 0}, 
  {41, 45, 0, 0, 0}, 
  {41, 48, 0, 0, 0}, 
  {41, 53, 0, 0, 0}, 

  {36, 0, 0, 0, 0}, 
  {36, 43, 0, 0, 0}, 
  {36, 48, 0, 0, 0}, 
  {36, 52, 0, 0, 0}, 

  {41, 0, 0, 0, 0}, 
  {41, 45, 0, 0, 0}, 
  {41, 48, 0, 0, 0}, 
  {41, 53, 0, 0, 0}, 

  {43, 0, 0, 0, 0}, 
  {43, 47, 0, 0, 0}, 
  {43, 50, 0, 0, 0}, 
  {43, 55, 0, 0, 0}, 

  //8 - 32
  {36, 64, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 62, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 60, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 59, 0, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 57, 0, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 55, 0, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  {29, 57, 0, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {31, 59, 0, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  //16 - 64
  {36, 60, 64, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 59, 62, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 57, 60, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 52, 55, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {31, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  //24 - 96
  {36, 0, 0, 60, 0}, 
  {43, 0, 0, 59, 0}, 
  {48, 0, 0, 60, 0}, 
  {0, 0, 0, 48, 0}, 

  {31, 0, 0, 47, 0}, 
  {38, 0, 0, 55, 0}, 
  {47, 0, 0, 50, 0}, 
  {47, 0, 0, 52, 0}, 

  {33, 0, 0, 48, 0}, 
  {40, 0, 0, 60, 0}, 
  {45, 0, 0, 59, 0}, 
  {45, 0, 0, 57, 0}, 

  {28, 0, 0, 59, 0}, 
  {35, 0, 0, 64, 0}, 
  {43, 0, 0, 67, 0}, 
  {43, 0, 0, 69, 0}, 

  {29, 0, 0, 65, 0}, 
  {36, 0, 0, 64, 0}, 
  {41, 0, 0, 62, 0}, 
  {41, 0, 0, 65, 0}, 

  {24, 0, 0, 64, 0}, 
  {31, 0, 0, 62, 0}, 
  {40, 0, 0, 60, 0}, 
  {40, 0, 0, 59, 0}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 55, 0}, 
  {41, 0, 0, 53, 0}, 
  {41, 0, 0, 52, 0}, 

  {31, 0, 0, 50, 0}, 
  {38, 0, 0, 53, 0}, 
  {43, 0, 0, 52, 0}, 
  {43, 0, 0, 50, 0}, 

  {36, 0, 0, 48, 0}, 
  {43, 0, 0, 50, 0}, 
  {48, 0, 0, 52, 0}, 
  {48, 0, 0, 53, 0}, 

  {33, 0, 0, 52, 0}, 
  {40, 0, 0, 57, 0}, 
  {45, 0, 0, 55, 0}, 
  {45, 0, 0, 53, 0}, 

  {28, 0, 0, 55, 0}, 
  {55, 0, 0, 53, 0}, 
  {43, 0, 0, 52, 0}, 
  {43, 0, 0, 50, 0}, 

  {29, 0, 0, 48, 0}, 
  {36, 0, 0, 45, 0}, 
  {41, 0, 0, 57, 0}, 
  {41, 0, 0, 59, 0}, 

  {24, 0, 0, 60, 0}, 
  {31, 0, 0, 59, 0}, 
  {40, 0, 0, 57, 0}, 
  {40, 0, 0, 55, 0}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 52, 0}, 
  {41, 0, 0, 50, 0}, 
  {41, 0, 0, 57, 0}, 

  {31, 0, 0, 55, 0}, 
  {38, 0, 0, 57, 0}, 
  {43, 0, 0, 55, 0}, 
  {47, 0, 0, 55, 0}, 

  //39 - 156
  {36, 0, 0, 67, 0}, 
  {43, 0, 0, 0, 64}, 
  {43, 0, 0, 0, 65}, 
  {48, 0, 0, 67, 0}, 
  {48, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 65}, 

  {31, 0, 0, 0, 67}, 
  {31, 0, 0, 0, 55}, 
  {38, 0, 0, 0, 57}, 
  {38, 0, 0, 0, 59}, 
  {47, 0, 0, 0, 60}, 
  {0, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 65}, 

  {33, 0, 0, 64, 0}, 
  {40, 0, 0, 0, 60}, 
  {40, 0, 0, 0, 62}, 
  {45, 0, 0, 0, 64}, 
  {45, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 53}, 

  {28, 0, 0, 0, 55}, 
  {28, 0, 0, 0, 57}, 
  {35, 0, 0, 0, 55}, 
  {35, 0, 0, 0, 53}, 
  {43, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 52}, 
  {43, 0, 0, 0, 53}, 
  {0, 0, 0, 0, 55}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 0, 57}, 
  {36, 0, 0, 0, 55}, 
  {41, 0, 0, 53, 0}, 
  {41, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 50}, 

  {24, 0, 0, 0, 52}, 
  {24, 0, 0, 0, 50}, 
  {31, 0, 0, 0, 48}, 
  {31, 0, 0, 0, 50}, 
  {40, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 53}, 
  {40, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 57}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 0, 57}, 
  {36, 0, 0, 0, 55}, 
  {41, 0, 0, 0, 57}, 
  {41, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 55}, 
  {31, 0, 0, 0, 57}, 
  {38, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 62}, 
  {0, 0, 0, 0, 64}, 
  {43, 0, 0, 0, 65}, 
  {0, 0, 0, 0, 67}, 

  {36, 0, 0, 64, 0}, 
  {43, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 62}, 
  {48, 0, 0, 64, 0}, 
  {48, 0, 0, 0, 62}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 62}, 
  {31, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 60}, 
  {38, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 60}, 
  {0, 0, 0, 0, 59}, 

  {33, 0, 0, 60, 0}, 
  {40, 0, 0, 0, 57}, 
  {40, 0, 0, 0, 59}, 
  {45, 0, 0, 0, 60}, 
  {45, 0, 0, 0, 48}, 
  {0, 0, 0, 0, 50}, 

  {28, 0, 0, 0, 52}, 
  {28, 0, 0, 0, 53}, 
  {35, 0, 0, 0, 52}, 
  {35, 0, 0, 0, 50}, 
  {43, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 0, 60}, 
  {36, 0, 0, 0, 59}, 
  {41, 0, 0, 57, 0}, 
  {41, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 53}, 

  {24, 0, 0, 0, 55}, 
  {24, 0, 0, 0, 53}, 
  {31, 0, 0, 0, 52}, 
  {31, 0, 0, 0, 53}, 
  {40, 0, 0, 0, 55}, 
  {40, 0, 0, 0, 57}, 
  {0, 0, 0, 0, 60}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 0, 60}, 
  {36, 0, 0, 0, 59}, 
  {41, 0, 0, 60, 0}, 
  {41, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 62}, 
  {38, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 57}, 
  {0, 0, 0, 0, 59}, 

  //266 - 1067
  {36, 60, 64, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 59, 62, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 57, 60, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 52, 55, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  //295 - 1180
  {57, 53, 0, 0, 29}, 
  {57, 0, 0, 0, 33}, 
  {62, 0, 0, 0, 36}, 
  {62, 0, 0, 0, 41}, 

  {59, 55, 0, 0, 31}, 
  {59, 0, 0, 0, 35}, 
  {62, 0, 0, 0, 38}, 
  {62, 0, 0, 0, 43}, 

  {36, 43, 55, 60, 64}

};