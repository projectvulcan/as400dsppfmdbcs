      *============================================================================================*
      *                                                                            SyazwanH/040202 *
      * PVDSPPFM                                                                                   *
      * Display Physical File Member (DBCS Enabled)                                                *
      *                                                                                            *
      * Version 1 Release 2 Modification 3                                                         *
      *                                                                                            *
      *  Compile as module. Then bind with file interface procedures APIs (PVDSPPFMU).             *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *                                                                                            *
      *============================================================================================*
      * Maintenance Log                                                                            *
      * ---------------                                                                            *
      * Trace  Date      Pgmr.     Notes                                                           *
      * ------------------------------------------------------------------------------------------ *
      * V1R3M3 20050220  SyazwanH  Added whole screen ASCII conversion function.                   *
      * V1R2M2 20041221  SyazwanH  Added quick fix to blocking/unblocking to display ASCII text.   *
      *        20040202  SyazwanH  New.                                                            *
      *============================================================================================*
      *---------------------------------------------------------------------------------------------
      * Compiler options
      *---------------------------------------------------------------------------------------------
      *
     HAltSeq(*None)
      *
      *---------------------------------------------------------------------------------------------
      * Files declaration
      *---------------------------------------------------------------------------------------------
      *
     FPvdsppfmd CF   E             WorkStn InfDs(Keys)
      *
      *---------------------------------------------------------------------------------------------
      * External procedures
      *---------------------------------------------------------------------------------------------
      *
     D OpenFile        Pr                  ExtProc('pvOpenFile')
     D  FilNamPtr                      *   Const
     D  LibNamPtr                      *   Const
     D  MbrNamPtr                      *   Const
     D  NRec                         10I 0
     D  RecSz                        10I 0
     D  RsnCode                      10I 0
      *
     D ReadRrn         Pr                  ExtProc('pvReadRrn')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadNext        Pr                  ExtProc('pvReadNext')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadPrev        Pr                  ExtProc('pvReadPrev')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadFirst       Pr                  ExtProc('pvReadFirst')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D ReadLast        Pr                  ExtProc('pvReadLast')
     D  MsgBuffPtr                     *
     D  MsgBuffSz                    10I 0
     D  RtnSz                        10I 0
     D  Rrn                          10I 0
     D  NRec                         10I 0
     D  RsnCode                      10I 0
      *
     D CloseFile       Pr                  ExtProc('pvCloseFile')
     D  RsnCode                      10I 0
      *
     D GetCurAddr      Pr            10I 0 ExtProc('QsnGetCsrAdr')
     D  CursorRow                    10I 0
     D  CursorClm                    10I 0
     D  LlEnvInfo                    10I 0
     D  ErrorCode                          Like(Qusec)
      *
     D GetCurAddrAid   Pr            10I 0 ExtProc('QsnGetCsrAdrAID')
     D  CursowRow                    10I 0
     D  CursorClm                    10I 0
     D  AIDCode                       1A
     D  LlEnvInfo                    10I 0
     D  ErrorCode                          Like(Qusec)
      *
     D RetrMbrDesc     Pr                  ExtPgm('QUSRMBRD')
     D  MbrDetl                            Like(Qusm0100)
     D  MbrDetlLen                   10I 0
     D  FmtName_2                     8A
     D  FilePath                     20A
     D  FileMbr                      10A
     D  OvrProc                       1A
     D  ErrorCode                          Like(Qusec)
      *
     D GetEbcdic       Pr                  ExtPgm('QDCXLATE')
     D  CvLen                         5P 0
     D  CvMsg                     16383A
     D  CvTbl                        10A
     D  CvSbc                        10A
     D  CvOut                     32767A
     D  CvBln                         5P 0
     D  CvCln                         5P 0
     D  CvDbc                        10A
     D  CvSio                         1A
     D  CvTyp                        10A
      *
     D System          Pr                  ExtPgm('QCMDEXC')
     D  ExtCmd                      512A   Options(*Varsize) Const
     D  ExtCmdLen                    15P 5 Const
      *
      *---------------------------------------------------------------------------------------------
      * Copybooks
      *---------------------------------------------------------------------------------------------
      *
      * Retrieve member description
     D/Copy Qsysinc/Qrpglesrc,Qusrmbrd
      * Error information
     D/Copy Qsysinc/Qrpglesrc,Qusec
      *
      *---------------------------------------------------------------------------------------------
      * Data structures
      *---------------------------------------------------------------------------------------------
      *
     D Keys            Ds
     D  FncKey               369    369A
      *
     D RecDsp          Ds
     D  WL01
     D  WL02
     D  WL03
     D  WL04
     D  WL05
     D  WL06
     D  WL07
     D  WL08
     D  WL09
     D  WL10
     D  WL11
     D  WL12
     D  WL13
     D  WL14
     D  WL15
     D  WL16
     D  WL17
     D  WL18
     D  ArrOfDsp                    131A   Dim(18) Inz(*Blanks)
     D                                     Overlay(RecDsp:1)
      *
     D                 Ds
     D  XNum3                  1      3S 0 Inz(*Zeros)
     D  XChar3                 1      3A
      *
     D                 Ds
     D  XNum10                 1     10S 0 Inz(*Zeros)
     D  XChar10                1     10A
      *
     D ValueHex        Ds
     D  ValueChar1                    1A   Inz(*Blanks)
     D  ValueChar2                    1A   Inz(*Blanks)
      *
     D IntDs           Ds
     D  IntNum                        5I 0 Inz(*Zeros)
     D  IntChar                       1A   Overlay(IntNum:2)
      *
     D FilePath        Ds            20    Qualified
     D  Name                   1     10A   Inz(*Blanks)
     D  Library               11     20A   Inz(*Blanks)
      *
      *---------------------------------------------------------------------------------------------
      * Variables and standalone fields
      *---------------------------------------------------------------------------------------------
      *
     D pFil            S             10A
     D pLib            S             10A
     D pMbr            S             10A
      *
     D MsgBuffPtr      S               *   Inz(%Addr(MsgBuff))
     D MsgBuff         S          32767A   Inz(*Blanks)
     D MsgBuffSz       S             10I 0 Inz(%Size(MsgBuff))
     D RtnSz           S             10I 0 Inz(*Zeros)
     D Rrn             S             10I 0 Inz(*Zeros)
     D NRec            S             10I 0 Inz(*Zeros)
     D RecSz           S             10I 0 Inz(*Zeros)
     D RsnCode         S             10I 0 Inz(*Zeros)
     D ErrorCode       S                   Like(Qusec) Inz(*Blanks)
     D MbrDetl         S                   Like(Qusm0100)
     D MbrDetlLen      S             10I 0 Inz(%Size(MbrDetl))
     D FormatName      S              8A   Inz('MBRD0100')
     D FileMbr         S             10A   Inz(*Blanks)
     D OvrProc         S              1A   Inz('0')
     D ExtCmd          S            512A   Inz(*Blanks)
     D ExtCmdLen       S             15P 5 Inz(%Size(ExtCmd))
     D CvLen           S              5P 0 Inz(*Zeros)
     D CvMsg           S          16383A   Inz(*Blanks)
     D CvTbl           S             10A   Inz('QEBCDIC')
     D CvTbl2          S             10A   Inz(*Blanks)
     D CvSbc           S             10A   Inz(*Blanks)
     D CvOut           S          32767A   Inz(*Blanks)
     D CvBln           S              5P 0 Inz(%Size(CvOut))
     D CvCln           S              5P 0 Inz(*Zeros)
     D CvDbc           S             10A   Inz('*SCGS')
     D CvSio           S              1A   Inz(*Blanks)
     D CvTyp           S             10A   Inz('*AE')
     D CursorRow       S             10I 0 Inz(*Zeros)
     D CursorClm       S             10I 0 Inz(*Zeros)
     D AIDCode         S              1A   Inz(*Blanks)
     D LlEnvInfo       S             10I 0 Inz(*Zeros)
     D ReturnCode      S             10I 0 Inz(*Zeros)
      *
     D QEnd            S              1N   Inz(*Off)
     D QReadPrev       S              1N   Inz(*Off)
     D QEndOfFile      S              1N   Inz(*Off)
     D QEndOfColumn    S              1N   Inz(*Off)
     D QBlocking       S              1N   Inz(*Off)
     D QBlockMode      S              1N   Inz(*Off)
     D QHexMode1       S              1N   Inz(*Off)
     D QHexMode2       S              1N   Inz(*Off)
     D QSearch         S              1N   Inz(*Off)
     D QFound          S              1N   Inz(*Off)
     D QPssr           S              1N   Inz(*Off)
      *
     D CurColumn       S             10I 0 Inz(1)
     D CurRecord       S             10I 0 Inz(1)
     D PrcRecord       S             10I 0 Inz(*Zeros)
     D LstRecord       S             10I 0 Inz(*Zeros)
     D NbrOfRecs       S             10I 0 Inz(*Zeros)
     D ArrOfRecs       S          32767A   Dim(18) Inz(*Blanks)
     D ArrOfRrno       S             10I 0 Dim(18) Inz(*Zeros)
     D ArrOfRecsI      S          32767A   Dim(18) Inz(*Blanks)
     D ArrOfRrnoI      S             10I 0 Dim(18) Inz(*Zeros)
     D NbrOfRecsI      S             10I 0 Inz(*Zeros)
     D ArrOfHex1       S            130A   Dim(18) Inz(*Blanks)
     D ArrOfHex2A      S            130A   Dim(18) Inz(*Blanks)
     D ArrOfHex2B      S            130A   Dim(18) Inz(*Blanks)
     D CurRrn          S             10I 0 Inz(*Zeros)
     D CurRow          S             10I 0 Inz(*Zeros)
     D CurClm          S             10I 0 Inz(*Zeros)
     D BlkFac1Rec      S             10I 0 Inz(*Zeros)
     D BlkFac1Pos      S             10I 0 Inz(*Zeros)
     D BlkFac2Rec      S             10I 0 Inz(*Zeros)
     D BlkFac2Pos      S             10I 0 Inz(*Zeros)
     D LastLine        S             10I 0 Inz(*Zeros)
     D CtlI            S                   Like(WCtl) Inz(*Blanks)
     D FndI            S                   Like(WFnd) Inz(*Blanks)
     D FoundRrn        S             10I 0 Inz(*Zeros)
     D FoundPos        S             10I 0 Inz(*Zeros)
     D FoundLen        S             10I 0 Inz(*Zeros)
     D FoundPosI       S             10I 0 Inz(*Zeros)
     D FoundStr        S             10I 0 Inz(*Zeros)
      *
     D Bal             S             10I 0 Inz(*Zeros)
     D Pos             S             10I 0 Inz(*Zeros)
     D Len             S             10I 0 Inz(*Zeros)
     D Nn              S             10I 0 Inz(*Zeros)
     D Mm              S             10I 0 Inz(*Zeros)
     D Xx              S             10I 0 Inz(*Zeros)
     D Rec             S             10I 0 Inz(*Zeros)
     D Cnt             S             10I 0 Inz(*Zeros)
      *
     D HexInt          S             10I 0 Inz(*Zeros)
     D HexChar         S              1A   Inz(*Blanks)
     D HexCode         S              2A   Inz(*Blanks)
     D Hex1Byte        S              1A   Inz(*Blanks)
     D Hex2Byte        S              1A   Inz(*Blanks)
     D OffSetA         S             10I 0 Inz(*Zeros)
     D OffSetB         S             10I 0 Inz(*Zeros)
     D XByte           S              1A   Inz(*Blanks)
     D XNumber         S             10I 0 Inz(*Zeros)
     D XNumber1        S             10I 0 Inz(*Zeros)
     D XNumber2        S             10I 0 Inz(*Zeros)
      *
     D AvlColumn       S             10I 0 Inz(130)
     D AvlLine         S             10I 0 Inz(18)
      *
      *---------------------------------------------------------------------------------------------
      * Constants
      *---------------------------------------------------------------------------------------------
      *
     D HexDigits       C                   Const('0123456789ABCDEF')
     D CStar           C                   Const('*')
     D CRule           C                   Const('....+....1....+....2....+....-
     D                                     3....+....4....+....5....+....6....+-
     D                                     ....7....+....8....+....9....+....0')
      *
      *---------------------------------------------------------------------------------------------
      * Parameters and keys list
      *---------------------------------------------------------------------------------------------
      *
     C     *Entry        Plist
     C                   Parm                    pFil
     C                   Parm                    pLib
     C                   Parm                    pMbr
      *
      *---------------------------------------------------------------------------------------------
      * Main logic
      *---------------------------------------------------------------------------------------------
      *
      /Free

         FilePath.Name = pFil;
         WFil = pFil;
         FilePath.Library = pLib;
         WLib = pLib;
         FileMbr = pMbr;

         CallP(E) RetrMbrDesc (MbrDetl : MbrDetlLen : FormatName :
                               FilePath : FileMbr : OvrProc :
                               ErrorCode);

         Qusm0100 = MbrDetl;
         WMbr = Qusmn02;

         OpenFile (%Addr(pFil) : %Addr(pLib) : %Addr(pMbr) :
                  NRec : RecSz : RsnCode);

         MsgBuffSz = RecSz;

         ExSr SrGetCurPos;
         DoW (QEnd = *Off);

            ExSr SrParseInput;
            ExSr SrFormatDisplay;

            Exfmt D01;

            WSts = *Blanks;
            QSearch = *Off;

            If (*In03 = *On) Or (*In12 = *On) Or
               ((FncKey = X'F1') And (WCtl = *Blanks));
               QEnd = *On;
               Iter;
            EndIf;

            Exsr SrReOpen;

         EndDo;

         CloseFile (RsnCode);

         *Inlr = *On;

       //---------------------------------------------------------------------------------------
       // Sub Routine SrFormatDisplay
       //   Read record from file and format for display
       //---------------------------------------------------------------------------------------

         BegSr SrFormatDisplay;

            Select;

               When (NRec = *Zeros);
                  %Subst(WL02:4) = '(Selected member contains no records)';
                  WRul = CRule + %Subst(CRule:1:30);
                  %Subst(WRul:1:1) = CStar;
                  WRem = ' Bottom';
                  *In55 = *On;
                  LeaveSr;

               When (*In24 = *On) And (*In51 = *On);
                  *In51 = *Off;
                  *In52 = *On;
                  LeaveSr;

               When (*In24 = *On) And (*In52 = *On);
                  *In52 = *Off;
                  *In53 = *On;
                  LeaveSr;

               When (*In24 = *On) And (*In53 = *On);
                  *In53 = *Off;
                  *In51 = *On;
                  LeaveSr;

               When (*In10 = *On) And (QHexMode1 = *Off) And (QHexMode2 = *Off);
                  *In81 = *On;
                  QHexMode1 = *On;
                  AvlColumn = 36;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In10 = *On) And (QHexMode1 = *Off) And (QHexMode2 = *On);
                  *In81 = *On;
                  QHexMode1 = *On;
                  AvlColumn = 130;
                  AvlLine = 4;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In10 = *On) And (QHexMode1 = *On) And (QHexMode2 = *Off);
                  *In81 = *Off;
                  QHexMode1 = *Off;
                  AvlColumn = 130;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In10 = *On) And (QHexMode1 = *On) And (QHexMode2 = *On);
                  *In81 = *Off;
                  QHexMode1 = *Off;
                  AvlColumn = 130;
                  AvlLine = 18;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In11 = *On) And (QHexMode2 = *Off);
                  QHexMode2 = *On;
                  AvlColumn = 130;
                  AvlLine = 4;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In11 = *On) And (QHexMode2 = *On);
                  QHexMode2 = *Off;
                  AvlColumn = 36;
                  AvlLine = 18;
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);

               When (*In16 = *On);
                  If (WFnd <> *Blanks);
                     Len = %CheckR(' ':WFnd:%Size(WFnd));
                     QSearch = *On;
                     If (WFnd = FndI);
                        Nn = %LookUp(FoundRrn:ArrOfRrno:1);
                        If (Nn = *Zeros);
                           FoundRrn = 1;
                        EndIf;
                        ExSr SrSearchAgain;
                     Else;
                        ExSr SrSearch;
                     EndIf;
                     FndI = WFnd;
                     If (QFound = *Off);
                        Rrn = ArrOfRrno(1);
                        ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                 RsnCode);
                        WSts = 'String not found before end of file reached.';
                     EndIf;
                  Else;
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     WSts = 'Specify string to find.';
                  EndIf;

               When (*In23 = *On);
                  If (QBlockMode = *Off);
                     ExSr SrGetCurPos;
                     If (CurRow > *Zeros);
                        If (CurRow >= 7 And CurRow <= 24) And
                           (CurClm >= 2 And CurRow <= 131);
                           If (QBlocking = *Off);
                              BlkFac1Rec = CurRow - 6;
                              BlkFac1Pos = (CurClm - 2) + 1;
                              QBlocking = *On;
                              WSts = 'Must specify end block.';
                           ElseIf ((CurRow - 6) < BlkFac1Rec) Or
                                  ((CurClm - 2) < BlkFac1Pos);
                              WSts = 'Position not valid.';
                           Else;
                              BlkFac2Rec = CurRow - 6;
                              BlkFac2Pos = (CurClm - 2) + 1;
                              QBlocking = *Off;
                              QBlockMode = *On;
                              WSts = 'Blocking accepted.';
                              *In77 = *Off;
                           EndIf;
                        Else;
                           WSts = 'Position not valid.';
                        EndIf;
                     EndIf;
                  Else;
                     QBlockMode = *Off;
                     WSts = 'Unblocked.';
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  EndIf;
                  If (QBlockMode = *Off) And (WSts <> 'Unblocked.');
                     LeaveSr;
                  Else;
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  EndIf;

               When (*In17 = *On);
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);
                  If (*In77 = *Off);
                     *In77 = *On;
                  Else;
                     *In77 = *Off;
                  EndIf;

               When (*In19 = *On);
                  If ((CurColumn - 1) <= RecSz) And ((CurColumn - 1) > *Zeros);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     CurColumn -= AvlColumn;
                     If (CurColumn < *Zeros);
                        CurColumn = 1;
                     EndIf;
                  Else;
                     LeaveSr;
                  EndIf;

               When (*In20 = *On);
                  If (((CurColumn + AvlColumn) + 1) <= RecSz);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     CurColumn += AvlColumn;
                     If (CurColumn > RecSz);
                        CurColumn = (RecSz - AvlColumn) + 1;
                     EndIf;
                  ElseIf (QEndOfColumn = *On);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     CurColumn = (RecSz - AvlColumn) + 1;
                     If (CurColumn <= *Zeros);
                        CurColumn = 1;
                     EndIf;
                  ElseIf (((CurColumn + AvlColumn) + 1) > RecSz);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     CurColumn = (RecSz - AvlColumn) + 1;
                  Else;
                     LeaveSr;
                  EndIf;

               When (*In61 = *On);
                  If ((CurRecord - 1) >= 1);
                     CurRecord = LstRecord - (36 - (AvlLine - NbrOfRecs));
                     If (CurRecord > *Zeros);
                        CurRecord += 1;
                     ElseIf (CurRecord <= *Zeros);
                        CurRecord = 1;
                     EndIf;
                     If (CurRecord > 1);
                        Rrn = ArrOfRrno(1);
                        ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                 RsnCode);
                        ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn: NRec :
                                  RsnCode);
                        QReadPrev = *On;
                     Else;
                        ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn :
                                   NRec : RsnCode);
                     EndIf;
                  Else;
                     ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                RsnCode);
                     WSts = 'First record shown.';
                  EndIf;

               When (*In62 = *On);
                  *In62 = *Off;
                  If ((LstRecord + 1) <= NRec);
                     CurRecord = LstRecord + 1;
                     Rrn = ArrOfRrno(NbrOfRecs);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  ElseIf (LstRecord = NRec);
                     CurRecord = (NRec - (AvlLine - 1)) + 1;
                     If (CurRecord <= *Zeros);
                        CurRecord = 1;
                     EndIf;
                     ReadLast (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                               RsnCode);
                     QReadPrev = *On;
                     WSts = 'Last record shown.';
                  Else;
                     ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                RsnCode);
                  EndIf;

               When WCtl = 'T';
                  CurRecord = 1;
                  ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                             RsnCode);

               When WCtl = 'B';
                  CurRecord = (NRec - (AvlLine - 1)) + 1;
                  If (CurRecord <= *Zeros);
                     CurRecord = 1;
                  EndIf;
                  ReadLast (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                            RsnCode);
                  QReadPrev = *On;

               When %Subst(WCtl:1:2) = 'W+';
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);
                  XChar10 = *All'0';
                  Pos = %CheckR(' ':WCtl);
                  If (Pos > *Zeros);
                     %Subst(XChar10:(10-(Pos-2))+1:(Pos-2)) =
                     %Subst(WCtl:3:(Pos-2));
                  EndIf;
                  Nn = XNum10;
                  If ((CurColumn + Nn) <= RecSz);
                     CurColumn += Nn;
                  Else;
                     CurColumn = (RecSz - AvlColumn) + 1;
                  EndIf;

               When %Subst(WCtl:1:2) = 'W-';
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);
                  XChar10 = *All'0';
                  Pos = %CheckR(' ':WCtl);
                  If (Pos > *Zeros);
                     %Subst(XChar10:(10-(Pos-2))+1:(Pos-2)) =
                     %Subst(WCtl:3:(Pos-2));
                  EndIf;
                  Nn = XNum10;
                  If ((CurColumn - Nn) > *Zeros);
                     CurColumn -= Nn;
                  Else;
                     CurColumn = 1;
                  EndIf;

               When %Subst(WCtl:1:1) = '+';
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);
                  XChar10 = *All'0';
                  Pos = %CheckR(' ':WCtl);
                  If (Pos > *Zeros);
                     %Subst(XChar10:(10-(Pos-1))+1:(Pos-1)) =
                     %Subst(WCtl:2:(Pos-1));
                  EndIf;
                  Nn = XNum10;
                  For Mm = 1 By 1 To Nn;
                     ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                               RsnCode);
                     If (RtnSz = *Zeros);
                        CurRecord = (NRec - (AvlLine - 1)) + 1;
                        If (CurRecord <= *Zeros);
                           CurRecord = 1;
                        EndIf;
                        ReadLast (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn :
                                  NRec : RsnCode);
                        QReadPrev = *On;
                        Leave;
                     EndIf;
                     CurRecord += 1;
                  EndFor;

               When %Subst(WCtl:1:1) = '-';
                  Rrn = ArrOfRrno(1);
                  ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                           RsnCode);
                  XChar10 = *All'0';
                  Pos = %CheckR(' ':WCtl);
                  If (Pos > *Zeros);
                     %Subst(XChar10:(10-(Pos-1))+1:(Pos-1)) =
                     %Subst(WCtl:2:(Pos-1));
                  EndIf;
                  Nn = XNum10;
                  For Mm = 1 By 1 To Nn;
                     ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                               RsnCode);
                     If (RtnSz = *Zeros);
                        ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn :
                                   NRec : RsnCode);
                        Leave;
                     EndIf;
                     CurRecord -= 1;
                  EndFor;

               When WCtl <> *Blanks;
                  XChar10 = *All'0';
                  Pos = %CheckR(' ':WCtl);
                  If (Pos > *Zeros);
                     %Subst(XChar10:(10-Pos)+1:Pos) =
                     %Subst(WCtl:1:Pos);
                  EndIf;
                  Nn = XNum10;
                  If (Nn > *Zeros);
                     If (Nn <= NRec);
                        Rrn = Nn;
                        ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                 RsnCode);
                     Else;
                        CurRecord = (NRec - (AvlLine -1)) + 1;
                        ReadLast (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                 RsnCode);
                     EndIf;
                  EndIf;

               Other;
                  If (*In51 = *Off And *In52 = *Off And *In53 = *Off And
                      *In54 = *Off And *In55 = *Off);
                     *In51 = *On;
                  EndIf;
                  If (CurRecord = 1);
                     ReadFirst (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                                RsnCode);
                  Else;
                     ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                               RsnCode);
                  EndIf;

            EndSl;

            NbrOfRecs = *Zeros;
            DoW (NbrOfRecs < AvlLine) And (RtnSz > *Zeros);
               NbrOfRecs += 1;
               ArrOfRecs(NbrOfRecs) = %Subst(MsgBuff:1:RecSz);
               ArrOfRrno(NbrOfRecs) = Rrn;
               If (QReadPrev = *Off);
                  ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                            RsnCode);
               Else;
                  ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                            RsnCode);
               EndIf;
            EndDo;

            If (NbrOfRecs > *Zeros);
               LstRecord = (CurRecord + NbrOfRecs) - 1;
               If (LstRecord > NRec);
                  LstRecord = NRec;
                  NbrOfRecs -= 1;
               EndIf;
            EndIf;

            NbrOfRecsI = NbrOfRecs;
            If (QReadPrev = *On);
               Mm = 0;
               For Nn = NbrOfRecs DownTo 1;
                  Mm += 1;
                  ArrOfRecsI(Nn) = ArrOfRecs(Mm);
                  ArrOfRrnoI(Nn) = ArrOfRrno(Mm);
               EndFor;
               For Nn = 1 By 1 To NbrOfRecs;
                  ArrOfRecs(Nn) = ArrOfRecsI(Nn);
                  ArrOfRrno(Nn) = ArrOfRrnoI(Nn);
               EndFor;
               QReadPrev = *Off;
            EndIf;

            If (NbrOfRecs < AvlLine) And (LstRecord = NRec);
               ArrOfRecs(NbrOfRecs+1) = *Blanks;
               %Subst(ArrOfRecs(NbrOfRecs+1):27) =
               '****** END OF DATA ******';
               NbrOfRecsI += 1;
               LastLine = NbrOfRecsI;
               QEndOfFile = *On;
            Else;
               LastLine = *Zeros;
               QEndOfFile = *Off;
            EndIf;

            XNum10 = ArrOfRrno(1);
            Pos = %Check('0':XChar10);
            If (Pos > *Zeros);
               WLin = %Subst(XChar10:Pos:(10-Pos)+1);
            EndIf;
            XNum10 = CurColumn;
            Pos = %Check('0':XChar10);
            If (Pos > *Zeros);
               WClm = %Subst(XChar10:Pos:(10-Pos)+1);
            EndIf;

            ExSr SrGetRecords;

            If (QHexMode1 = *Off) Or
               ((QHexMode1 = *On) And (QHexMode2 = *On));
               ExSr SrGetRule;
            Else;
            EndIf;

            If (QEndOfFile = *On);
               WRem = ' Bottom';
            Else;
               WRem = 'More...';
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrGetRecords
       //   Formats record on display
       //-------------------------------------------------------------------------------------------

         BegSr SrGetRecords;

            Pos = CurColumn;
            Len = 130;

            ArrOfDsp(*) = *Blanks;
            For PrcRecord = 1 By 1 To NbrOfRecsI;
               If (*In77 = *On);
                  CvMsg = %Subst(ArrOfRecs(PrcRecord):1:%Size(ArrOfRecs));
                  CvLen = %Size(ArrOfRecs);
                  CallP(E) GetEbcdic (CvLen : CvMsg : CvTbl :
                                      CvSbc : CvOut : CvBln :
                                      CvCln : CvDbc : CvSio :
                                      CvTyp);
                  If (CvOut <> *Blanks);
                     %Subst(ArrOfRecs(PrcRecord):1:%Size(ArrOfRecs)) = CvOut;
                  EndIf;
               EndIf;
               Select;
                  When (QHexMode1 = *On) And (QHexMode2 = *Off);
                     ExSr SrFmtHex1;
                     If (QEndOfFile = *On) And
                        (PrcRecord = LastLine);
                        %Subst(ArrOfDsp(PrcRecord):2) =
                        %Subst(ArrOfRecs(PrcRecord):1:Len);
                     Else;
                        %Subst(ArrOfDsp(PrcRecord):2) =
                        %Subst(ArrOfHex1(PrcRecord):1:Len);
                     EndIf;
                  When (QHexMode1 = *On) And (QHexMode2 = *On);
                     ExSr SrFmtHex2;
                     If (QEndOfFile = *On) And
                        (PrcRecord = LastLine);
                        %Subst(ArrOfDsp((PrcRecord * 4) - 3):2) =
                        %Subst(ArrOfRecs(PrcRecord):1:Len);
                     Else;
                        %Subst(ArrOfDsp((PrcRecord * 4) - 3):2) =
                        %Subst(ArrOfRecs(PrcRecord):Pos:Len);
                        %Subst(ArrOfDsp((PrcRecord * 4) - 2):2) =
                        %Subst(ArrOfHex2A(PrcRecord):1:Len);
                        %Subst(ArrOfDsp((PrcRecord * 4) - 1):2) =
                        %Subst(ArrOfHex2B(PrcRecord):1:Len);
                     EndIf;
                  Other;
                     If (QEndOfFile = *On) And
                        (PrcRecord = LastLine);
                        %Subst(ArrOfDsp(PrcRecord):2) =
                        %Subst(ArrOfRecs(PrcRecord):1:Len);
                     Else;
                        %Subst(ArrOfDsp(PrcRecord):2) =
                        %Subst(ArrOfRecs(PrcRecord):Pos:Len);
                     EndIf;
               EndSl;

               If (QBlockMode = *On);
                  If (PrcRecord >= BlkFac1Rec) And (PrcRecord <= BlkFac2Rec);
                     CvMsg = %Subst(ArrOfDsp(PrcRecord):(BlkFac1Pos + 1):
                             (BlkFac2Pos - BlkFac1Pos) + 1);
                     CvLen = (BlkFac2Pos - BlkFac1Pos) + 1;
                     CallP(E) GetEbcdic (CvLen : CvMsg : CvTbl :
                                         CvSbc : CvOut : CvBln :
                                         CvCln : CvDbc : CvSio :
                                         CvTyp);
                     If (CvOut <> *Blanks);
                        For Cnt = 1 By 1 To CvLen;
                           If (%Subst(ArrOfDsp(PrcRecord):(BlkFac1Pos + 1)+
                               Cnt-1:1) = X'40');
                              %Subst(CvOut:Cnt:1) = X'40';
                           EndIf;
                        EndFor;
                        %Subst(ArrOfDsp(PrcRecord):(BlkFac1Pos + 1):
                        (BlkFac2Pos - BlkFac1Pos + 1)) =
                        %Subst(CvOut:1:(BlkFac2Pos - BlkFac1Pos) + 1);
                     EndIf;
                  EndIf;
               EndIf;

               If (QHexMode2 = *Off);
                  For Nn = 1 By 1 To Len;
                     HexChar = %Subst(ArrOfDsp(PrcRecord):(Nn + 1):1);
                     If (HexChar <> X'0E') And (HexChar <> X'0F');
                        ExSr SrStringToHex;
                        If (HexInt < 64);
                           %Subst(ArrOfDsp(PrcRecord):(Nn + 1):1) = X'1F';
                        EndIf;
                     EndIf;
                  EndFor;
               ElseIf (QHexMode2 = *On) And (QHexMode1 = *On);
                  For Nn = 1 By 1 To Len;
                     HexChar = %Subst(ArrOfDsp((PrcRecord * 4) - 3):(Nn + 1):1);
                     If (HexChar <> X'0E') And (HexChar <> X'0F');
                        ExSr SrStringToHex;
                        If (HexInt < 64);
                           %Subst(ArrOfDsp((PrcRecord * 4) - 3):(Nn + 1):1) =
                           X'1F';
                        EndIf;
                     EndIf;
                  EndFor;
               Else;
                  For Nn = 1 By 1 To Len;
                     HexChar = %Subst(ArrOfDsp(PrcRecord):(Nn + 1):1);
                     If (HexChar <> X'0E') And (HexChar <> X'0F');
                        ExSr SrStringToHex;
                        If (HexInt < 64);
                           %Subst(ArrOfDsp(PrcRecord):(Nn + 1):1) = X'1F';
                        EndIf;
                     EndIf;
                  EndFor;
               EndIf;

               If (QSearch = *On) And (QFound = *On);
                  If (ArrOfRrno(PrcRecord) = FoundRrn);
                     If (CurColumn > 1);
                        FoundPosI = (FoundPos - CurColumn) + 1;
                     Else;
                        FoundPosI = FoundPos;
                     EndIf;
                     For Nn = FoundPosI DownTo 1;
                        If (QHexMode2 = *Off);
                           If %Subst(ArrOfDsp(PrcRecord):Nn:1) = ' ';
                              %Subst(ArrOfDsp(PrcRecord):Nn:1) = X'22';
                              Leave;
                           EndIf;
                        Else;
                           If %Subst(ArrOfDsp((PrcRecord * 4) - 3):Nn:1) = ' ';
                              %Subst(ArrOfDsp((PrcRecord * 4) - 3):Nn:1) =
                              X'22';
                              Leave;
                           EndIf;
                        EndIf;
                     EndFor;
                     For Nn = FoundPosI By 1 To AvlColumn;
                        If (QHexMode2 = *Off);
                           If %Subst(ArrOfDsp(PrcRecord):Nn:1) = ' ';
                              %Subst(ArrOfDsp(PrcRecord):Nn:1) = X'20';
                              Leave;
                           EndIf;
                        Else;
                           If %Subst(ArrOfDsp((PrcRecord * 4) - 3):Nn:1) = ' ';
                              %Subst(ArrOfDsp((PrcRecord * 4) - 3):Nn:1) =
                              X'20';
                              Leave;
                           EndIf;
                        EndIf;
                     EndFor;
                  EndIf;
               EndIf;

            EndFor;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrGetRule
       //   Build record ruler on top of display
       //-------------------------------------------------------------------------------------------

         BegSr SrGetRule;

            If (CurColumn = 1);
               WRul = CRule + %Subst(CRule:1:30);
               %Subst(WRul:1:1) = CStar;
            Else;
               XNum10 = CurColumn;
               XChar3 = %Subst(XChar10:8:3);
               Nn = XNum3;
               DoW (Nn > 100);
                  Nn = Nn - 100;
               EndDo;
               Mm = (100 - Nn) + 1;

               Pos = Nn;
               Len = Mm;
               Bal = Len + 1;
               WRul = %Subst(CRule:Pos:Len);

               Nn = Pos + Len;
               DoW (Nn > 100);
                  Nn = Nn - 100;
               EndDo;
               Mm = (100 - Nn) + 1;

               Pos = Nn;
               If ((AvlColumn - Bal) + 1) > ((100 - Pos) + 1);
                  Len = (100 - Pos) + 1;
                  %Subst(WRul:Bal) = %Subst(CRule:Pos:Len);
                  Bal = Bal + Len;

                  Pos = 1;
                  Len = (AvlColumn - Bal) + 1;
                  %Subst(WRul:Bal) = %Subst(CRule:Pos:Len);
               Else;
                  Len = (AvlColumn - Bal) + 1;
                  %Subst(WRul:Bal) = %Subst(CRule:Pos:Len);
               EndIf;
            EndIf;

            If ((CurColumn + AvlColumn) - 1 > RecSz);
               If (((CurColumn + AvlColumn) - 1) > AvlColumn);
                  Len = ((CurColumn + AvlColumn) - 1) - RecSz;
                  Pos = (AvlColumn - Len) + 1;
               Else;
                  Len = RecSz;
                  Pos = Len + 1;
               EndIf;
               %Subst(WRul:Pos) = *Blanks;
               QEndOfColumn = *On;
            Else;
               QEndOfColumn = *Off;
            EndIf;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrFmtHex1
       //   Format display in hex screen type 1
       //-------------------------------------------------------------------------------------------

         BegSr SrFmtHex1;

            Xx = 1;

            For Nn = 1 By 1 To 36;
               HexChar = %Subst(ArrOfRecs(PrcRecord):((Pos + Nn) - 1):1);
               ExSr SrStringToHex;
               %Subst(ArrOfHex1(PrcRecord):Xx:2) = HexCode;
               Xx += 2;

               If (Xx = 9 Or Xx = 18 Or Xx = 27 Or Xx = 36 Or
                   Xx = 45 Or Xx = 54 Or Xx = 63 Or Xx = 72);
               Xx += 1;
               EndIf;
            EndFor;

            Xx = 84;
            %Subst(ArrOfHex1(PrcRecord):Xx:1) = '*';

            Xx = 85;
            %Subst(ArrOfHex1(PrcRecord):Xx:36) =
            %Subst(ArrOfRecs(PrcRecord):Pos:36);

            Xx = 121;
            %Subst(ArrOfHex1(PrcRecord):Xx:1) = '*';

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrFmtHex2
       //   Format display in hex screen type 2
       //-------------------------------------------------------------------------------------------

         BegSr SrFmtHex2;

            For Nn = 1 By 1 To 130;
               HexChar = %Subst(ArrOfRecs(PrcRecord):((Pos + Nn) - 1):1);
               If (((Pos + Nn) - 1) <= RecSz);
                  ExSr SrStringToHex;
                  %Subst(ArrOfHex2A(PrcRecord):Nn:1) =
                  %Subst(HexCode:1:1);
                  %Subst(ArrOfHex2B(PrcRecord):Nn:1) =
                  %Subst(HexCode:2:1);
               Else;
                  %Subst(ArrOfHex2A(PrcRecord):Nn:(130 - Nn) + 1) = *Blanks;
                  %Subst(ArrOfHex2B(PrcRecord):Nn:(130 - Nn) + 1) = *Blanks;
               EndIf;
            EndFor;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrParseInput
       //   Parse user input from display
       //-------------------------------------------------------------------------------------------

         BegSr SrParseInput;

            CtlI = *Blanks;
            Xx = 1;
            If (WCtl <> *Blanks);
               For Nn = 1 By 1 To %Size(WCtl);
                  If (%Subst(WCtl:Nn:1) <> *Blanks);
                     %Subst(CtlI:Xx:1) = %Subst(WCtl:Nn:1);
                     Xx += 1;
                  EndIf;
               EndFor;
            EndIf;
            WCtl = CtlI;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrSearch
       //   Search for a string
       //-------------------------------------------------------------------------------------------

         BegSr SrSearch;

            Rec = *Zeros;

            Rrn = ArrOfRrno(1);
            ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec : RsnCode);

            QFound = *Off;
            DoW (RtnSz > *Zeros) And (QFound = *Off);
               Rec += 1;
               Pos = %Scan(%Subst(WFnd:1:Len):%Subst(MsgBuff:1:MsgBuffSz):1);
               If (Pos > *Zeros);
                  QFound = *On;
                  FoundPos = Pos;
                  FoundLen = Len;
                  If (FoundPos > (CurColumn + AvlColumn));
                     Xx = FoundPos + Len;
                     CurColumn = (Xx - AvlColumn) + 1;
                  ElseIf (FoundPos < CurColumn);
                     Xx = FoundPos + Len;
                     If (((Xx - AvlColumn) + 1) > *Zeros);
                        CurColumn = (Xx - AvlColumn) + 1;
                     Else;
                        CurColumn = 1;
                     EndIf;
                  EndIf;
                  FoundRrn = Rrn;
                  If (Rec = 1) Or (Rec = 2);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  Else;
                     Rrn = FoundRrn;
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  EndIf;
                  Iter;
               EndIf;

               ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                         RsnCode);
            EndDo;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrSearchAgain
       //   Search again for a string
       //-------------------------------------------------------------------------------------------

         BegSr SrSearchAgain;

            Rec = *Zeros;

            Rrn = FoundRrn;
            ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec : RsnCode);

            QFound = *Off;
            FoundStr = FoundPos + 1;
            DoW (RtnSz > *Zeros) And (QFound = *Off);
               Rec += 1;
               Pos = %Scan(%Subst(WFnd:1:Len):%Subst(MsgBuff:1:MsgBuffSz):
                     FoundStr);
               If (Pos > *Zeros);
                  QFound = *On;
                  FoundPos = Pos;
                  FoundLen = Len;
                  If (FoundPos > (CurColumn + AvlColumn));
                     Xx = FoundPos + Len;
                     CurColumn = (Xx - AvlColumn) + 1;
                  ElseIf (FoundPos < CurColumn);
                     Xx = FoundPos + Len;
                     If (((Xx - AvlColumn) + 1) > *Zeros);
                        CurColumn = (Xx - AvlColumn) + 1;
                     Else;
                        CurColumn = 1;
                     EndIf;
                  EndIf;
                  FoundRrn = Rrn;
                  Nn = %LookUp(Rrn:ArrOfRrno:1);
                  If (Nn > *Zeros);
                     Rrn = ArrOfRrno(1);
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  Else;
                     Rrn = FoundRrn;
                     ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                     ReadPrev (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                              RsnCode);
                  EndIf;
                  Iter;
               EndIf;

               FoundStr = 1;
               ReadNext (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec :
                         RsnCode);
            EndDo;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrReOpen
       //   Closes and reopens file
       //-------------------------------------------------------------------------------------------

         BegSr SrReOpen;

            CurRrn = Rrn;

            CloseFile (RsnCode);
            OpenFile (%Addr(pFil) : %Addr(pLib) : %Addr(pMbr) :
                      NRec : RecSz : RsnCode);

            Rrn = CurRrn;
            ReadRrn (MsgBuffPtr : MsgBuffSz : RtnSz : Rrn : NRec : RsnCode);

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrGetCurPos
       //   Get cusror location on screen
       //-------------------------------------------------------------------------------------------

         BegSr SrGetCurPos;

            CursorRow = *Zeros;
            CursorClm = *Zeros;
            LlEnvInfo = *Zeros;
            Reset Qusec;
            Qusbprv = %Size(Qusec);
            ErrorCode = Qusec;
            ReturnCode = *Zeros;

            ReturnCode = GetCurAddr(CursorRow : CursorClm : LlEnvInfo :
                                    ErrorCode);

            // We may use the following code sometime in the future.
            // ReturnCode = GetCurAddrAID(CursorRow : CursorClm : AIDCode :
            //                            LlEnvInfo : ErrorCode);

            If (CursorRow > *Zeros) And (CursorClm > *Zeros);
               CurRow = CursorRow;
               CurClm = CursorClm;
            Else;
               CurRow = 20;
               CurClm = 1;
            EndIf;

            XRow = CurRow;
            XCol = CurClm;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrStringToHex
       //   Convert string to hex to integer
       //-------------------------------------------------------------------------------------------

         BegSr SrStringToHex;

            IntChar = (HexChar);
            OffSetA = (%Div(IntNum:16));
            OffSetB = (%Rem(IntNum:16));
            ValueChar1 = (%Subst(HexDigits:OffSetA+1:1));
            ValueChar2 = (%Subst(HexDigits:OffSetB+1:1));

            XByte = ValueChar1;
            ExSr SrGetNumber;
            XNumber1 = XNumber;

            XByte = ValueChar2;
            ExSr SrGetNumber;
            XNumber2 = XNumber;

            XNumber1 = (XNumber1 * 16);
            XNumber = (XNumber1 + XNumber2);

            HexInt = XNumber;
            HexCode = ValueChar1 + ValueChar2;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine SrGetNumber
       //   Convert number from hex values
       //-------------------------------------------------------------------------------------------

         BegSr SrGetNumber;

            Select;

               When XByte = '0';
                  XNumber = 0;

               When XByte = '1';
                  XNumber = 1;

               When XByte = '2';
                  XNumber = 2;

               When XByte = '3';
                  XNumber = 3;

               When XByte = '4';
                  XNumber = 4;

               When XByte = '5';
                  XNumber = 5;

               When XByte = '6';
                  XNumber = 6;

               When XByte = '7';
                  XNumber = 7;

               When XByte = '8';
                  XNumber = 8;

               When XByte = '9';
                  XNumber = 9;

               When XByte = 'A';
                  XNumber = 10;

               When XByte = 'B';
                  XNumber = 11;

               When XByte = 'C';
                  XNumber = 12;

               When XByte = 'D';
                  XNumber = 13;

               When XByte = 'E';
                  XNumber = 14;

               When XByte = 'F';
                  XNumber = 15;

            EndSl;

         EndSr;

       //-------------------------------------------------------------------------------------------
       // Sub Routine *Pssr
       //   Program exception handling
       //-------------------------------------------------------------------------------------------

         BegSr *Pssr;

            QPssr = *On;
            CloseFile (RsnCode);
            QEnd = *On;

         EndSr '*DETL';

      /End-Free
      *
