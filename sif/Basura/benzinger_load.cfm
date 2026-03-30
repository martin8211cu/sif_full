<cfsetting enablecfoutputonly="yes">


<cfset titulo = "Puesto No. " & (Int(Rand()*9999)+2000)>
<cfset escalaFR = Int(Rand()*70+50)>
<cfset escalaFL = Int(Rand()*70+50)>
<cfset escalaBR = Int(Rand()*70+50)>
<cfset escalaBL = Int(Rand()*70+50)>
<cfset toleraFR = Int(Rand()*10)>
<cfset toleraFL = Int(Rand()*10)>
<cfset toleraBR = Int(Rand()*10)>
<cfset toleraBL = Int(Rand()*10)>
<cfset esIntrov = 0>
<cfset esExtrov = 1>
<cfset esBalance = 0>
<cfset listaFR = 'Alegre,Jovial,Facilidad de Palabra'>
<cfset listaFL = 'Alegre,Jovial,Facilidad de Palabra'>
<cfset listaBR = 'Alegre,Jovial,Facilidad de Palabra'>
<cfset listaBL = 'Alegre,Jovial,Facilidad de Palabra'>
<cfset meneco = "FR">


<cfoutput>ok=#1
#&titulo=#URLEncodedFormat(titulo)
#&escalaFR=#URLEncodedFormat(escalaFR)
#&escalaFL=#URLEncodedFormat(escalaFL)
#&escalaBR=#URLEncodedFormat(escalaBR)
#&escalaBL=#URLEncodedFormat(escalaBL)
#&toleraFR=#URLEncodedFormat(toleraFR)
#&toleraFL=#URLEncodedFormat(toleraFL)
#&toleraBR=#URLEncodedFormat(toleraBR)
#&toleraBL=#URLEncodedFormat(toleraBL)
#&listaFR=#URLEncodedFormat(ListChangeDelims(listaFR,Chr(10)))
#&listaFL=#URLEncodedFormat(ListChangeDelims(listaFL,Chr(10)))
#&listaBR=#URLEncodedFormat(ListChangeDelims(listaBR,Chr(10)))
#&listaBL=#URLEncodedFormat(ListChangeDelims(listaBL,Chr(10)))
#&esIntrov=#URLEncodedFormat(esIntrov)
#&esExtrov=#URLEncodedFormat(esExtrov)
#&esBalance=#URLEncodedFormat(esBalance)
#&meneco=#URLEncodedFormat(meneco)
#</cfoutput>