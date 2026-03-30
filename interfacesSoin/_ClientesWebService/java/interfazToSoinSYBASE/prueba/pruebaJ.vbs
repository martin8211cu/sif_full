set LvarArgs = WScript.Arguments
if LvarArgs.count = 1 then
  LvarNum = LvarArgs(0)
else
  LvarNum = ""
end if
dim LvarFSO

set LvarFSO = CreateObject("Scripting.FileSystemObject")

LvarFSO.createTextFile("msg_out" & LvarNum & ".txt")

set LvarInFile = LvarFSO.GetFile("msg" & LvarNum & ".txt")
set LvarIn = LvarInFile.OpenAsTextStream(1)
dim LvarRPT(100)
LvarRPT_I = 0
LvarNum_free = false
LvarLin1 = LvarIn.ReadLine
Do While Not LvarIn.AtEndOfStream
	LvarLin = LvarIn.ReadLine
	if mid(LvarLin,2,10)="----------" then
	  LvarLin = LvarIn.ReadLine
	  if not LvarNum_free then
	    LvarRPT(LvarRPT_I) = mid(LvarLin,1,32) & mid(LvarLin,70)
	    LvarRPT_I = LvarRPT_I + 1
	  else
	    for j = 0 to LvarRPT_I
		if mid(LvarRPT(j),1,25) = mid(LvarLin,1,25) then
		  exit for
		end if
	    next
	    LvarRPT(j) = LvarRPT(j) & mid(LvarLin,28)
	  end if
	elseif not LvarNum_free then
	  LvarNum_free = instr(LvarLin,"Num_free")>0
	end if
Loop
LvarIn.Close

set LvarOutFile = LvarFSO.GetFile("msg_out" & LvarNum & ".txt")
set LvarOut = LvarOutFile.OpenAsTextStream(2, true)
LvarOut.WriteLine(LvarLin1)
LvarOut.WriteLine(" Parameter Name                 Run Value   Unit                 Type       Num_free    Num_active  Pct_act Max_Used    Num_Reuse  ")
LvarOut.WriteLine(" ------------------------------ ----------- -------------------- ---------- ----------- ----------- ------- ----------- -----------") 
for i=0 to LvarRPT_I
	LvarOut.WriteLine(LvarRPT(i)) 
next
LvarOut.Close
LvarFSO.CopyFile   "msg_out" & LvarNum & ".txt", "msg" & LvarNum & ".txt"
LvarFSO.DeleteFile "msg_out" & LvarNum & ".txt"

