pragma(LDC_no_moduleinfo);
pragma(LDC_no_typeinfo);


template Crypt(string value)
{
  auto k1 = __TIME__[4];
  auto k2 = __TIME__[7];

  struct Dongs(string value)
  {
    alias get this;
    string get() @property const
    {
      string q;
      foreach (i, c; value)
        q ~= c ^ (k1 + i % (1 + k2));
      return q;
    }
  }

  string encrypt()
  {
    string q;
    foreach (i, c; value)
      q ~= c ^ (k1 + i % (1 + k2));
    return q;
  }

  enum Crypt = Dongs!encrypt();
}

// Stolen names from a previous crackme cause i'm lazy
// https://github.com/tghack/tg20hack/blob/master/re/combat_ship3/src/answers.h

static skid0 = Crypt!"odinz";
static skid1 = Crypt!"botnetwZ";
static skid2 = Crypt!"Pepur";
static skid3 = Crypt!"aleksCha";
static skid4 = Crypt!"nono";
static skid5 = Crypt!"bo9";
static skid6 = Crypt!"wZbz";
static skid7 = Crypt!"bopur";
static skid8 = Crypt!"bokake";
static skid9 = Crypt!"Peo_o";
static skid10 = Crypt!"o_oaleks";
static skid11 = Crypt!"kakeSmoking";
static skid12 = Crypt!"boPe";
static skid13 = Crypt!"jezzy";
static skid14 = Crypt!"botnetSmoking";
static skid15 = Crypt!"jeil";
static skid16 = Crypt!"nobo";
static skid17 = Crypt!"coNora";
static skid18 = Crypt!"noPe";
static skid19 = Crypt!"noaleks";
static skid20 = Crypt!"jeroy";
static skid21 = Crypt!"maritiz";
static skid22 = Crypt!"botnetkriste";
static skid23 = Crypt!"o_oNora";
static skid24 = Crypt!"purje";
static skid25 = Crypt!"noco";
static skid26 = Crypt!"jebz";
static skid27 = Crypt!"Ingeup";
static skid28 = Crypt!"bono";
static skid29 = Crypt!"saurus9";
static skid30 = Crypt!"sauruskriste";
static skid31 = Crypt!"purkake";
static skid32 = Crypt!"NoraInge";
static skid33 = Crypt!"aleksno";
static skid34 = Crypt!"upkongen";
static skid35 = Crypt!"hacwZ";
static skid36 = Crypt!"Chamariti";
static skid37 = Crypt!"botneto_o";
static skid38 = Crypt!"maritizzy";
static skid39 = Crypt!"kongenbo";
static skid40 = Crypt!"Gunil";
static skid41 = Crypt!"odinSmoking";
static skid42 = Crypt!"bolbz";
static skid43 = Crypt!"purbotnet";
static skid44 = Crypt!"bzsaurus";
static skid45 = Crypt!"bolmariti";
static skid46 = Crypt!"GunPe";
static skid47 = Crypt!"alekskongen";
static skid48 = Crypt!"royroy";
static skid49 = Crypt!"bzpur";
static skid50 = Crypt!"kongenInge";
static skid51 = Crypt!"Smokingodin";
static skid52 = Crypt!"o_oNora";
static skid53 = Crypt!"o_o9";
static skid54 = Crypt!"odinodin";
static skid55 = Crypt!"bobo";
static skid56 = Crypt!"hachac";
static skid57 = Crypt!"Smokingkake";
static skid58 = Crypt!"Ingeodin";
static skid59 = Crypt!"Smokingup";
static skid60 = Crypt!"o_oco";
static skid61 = Crypt!"zGun";
static skid62 = Crypt!"IngeCha";
static skid63 = Crypt!"Ingepur";
static skid64 = Crypt!"botnetz";
static skid65 = Crypt!"Gun9";
static skid66 = Crypt!"zzyil";
static skid67 = Crypt!"kristeno";
static skid68 = Crypt!"maritibz";
static skid69 = Crypt!"Gunup";
static skid70 = Crypt!"kongenil";
static skid71 = Crypt!"Ingezzy";
static skid72 = Crypt!"Noraz";
static skid73 = Crypt!"9botnet";
static skid74 = Crypt!"bolpur";
static skid75 = Crypt!"bolzzy";
static skid76 = Crypt!"alekswZ";
static skid77 = Crypt!"ilbotnet";
static skid78 = Crypt!"odinaleks";
static skid79 = Crypt!"ilo_o";
static skid80 = Crypt!"bolsaurus";
static skid81 = Crypt!"odinz";
static skid82 = Crypt!"wZkongen";
static skid83 = Crypt!"coz";
static skid84 = Crypt!"botnetmariti";
static skid85 = Crypt!"noil";
static skid86 = Crypt!"coz";
static skid87 = Crypt!"bokongen";
static skid88 = Crypt!"Gunkongen";
static skid89 = Crypt!"upz";
static skid90 = Crypt!"kongenInge";
static skid91 = Crypt!"zzyInge";
static skid92 = Crypt!"Agent Pulidipper";
static skid93 = Crypt!"Pebo";
static skid94 = Crypt!"Gun9";
static skid95 = Crypt!"wZkriste";
static skid96 = Crypt!"kristebol";
static skid97 = Crypt!"wZPe";
static skid98 = Crypt!"noGun";
static skid99 = Crypt!"bolmariti";
static skidflag = Crypt!"{ imgay } ";
