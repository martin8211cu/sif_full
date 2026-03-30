<!---

<font color=""
Esto es mayor que = >
Esto es menor que = <
Esto es apostrofe que = '
Esto es comillas que = ""
Esto es amperson que = &
Esto es A tildada = Á
<cfset x = "
Esto es mayor que = >
Esto es menor que = <
Esto es apostrofe que = '
Esto es comillas que = ""
Esto es amperson que = &
Esto es A tildada = Á
">
<BR>


<cfdump var="#tobase64(toBinary("AAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BBQkNERUZHSElKS0xNTk9QUVJTVFVWV1hZWltcXV5fYGFiY2RlZmdoaWprbG1ub3BxcnN0dXZ3eHl6e3x9fn+AgYKDhIWGh4iJiouMjY6PkJGSk5SVlpeYmZqbnJ2en6ChoqOkpaanqKmqq6ytrq+wsbKztLW2t7i5uru8vb6/wMHCw8TFxsfIycrLzM3Oz9DR0tPU1dbX2Nna29zd3t/g4eLj5OXm5+jp6uvs7e7v8PHy8/T19vf4+fr7/P3+/w=="))#">
<br>

<cfdump var="#toString(toBinary("RXN0byBlcyB1bmEgwrRQcnVlYsOkIGRlbCBFbmNvZGVyNjQgw4HDicONw5PDmg=="),"utf-8")#">
<cfoutput>

<BR>
#toBase64("Esto es una ´Pruebä del Encoder64 ÁÉÍÓÚ","utf-8")#
<BR>
	#X#
	<BR>
	#XMLformat(X)#
	#xmlparse("
<xml>
Esto es mayor que = &gt; 
Esto es menor que = &lt;
Esto es apostrofe que = &apos;
Esto es comillas que = &quot;
Esto es amperson que = &amp;
Esto es A tildada = &##195;
</xml>")#
</cfoutput>

--->

<cfhttp 
		method="get" 
		url="https://www.gruponacion.biz/WssOIN/sERVICIO.ASMX?wsdl"
		 result="hola">
</cfhttp>
<cfdump var="#hola#">
<cfabort>

<cfinvoke 
 webservice="https://www.gruponacion.biz/WssOIN/sERVICIO.ASMX?wsdl"
 method="queryDataset"
 returnvariable="dsAgexncias">
</cfinvoke>
<cfdump var="#dsAgencias#">
<cfset x = dsAgencias.get_any()>

<cfdump var="#x[1].getAsString()#">
<BR>
<cfdump var="#x[2].getAsString()#">
<cfset RssAgencias = fnDatasetToRecordsets(dsAgencias)>
<cfdump var="#RssAgencias#">
<!--- Convierte un dataset de .NET a un conjunto de Recordsets de Coldfusion dentro de un struct --->
<cfscript>
	function fnDatasetToRecordsets (pDataset)
	{
		var LvarRSs		  = structNew();
		var LvarTypes	  = structNew();
		var LvarXML		  = pDataset.get_any();
		var LvarXML1	  = xmlParse(LvarXML[1]);
		var LvarXmlTables = LvarXML1["xs:schema"]["xs:element"]["xs:complexType"]["xs:choice"];
		var LvarXML2	  = xmlParse(LvarXML[2]);
		var LvarXmlCols   = "";
		var LvarName	  = "";
		var LvarRows 	  = "";
		var i = 0;
		var j = 0;

		// Crea el Recordset
		for (i = 1; i LTE arrayLen(LvarXmlTables.xmlChildren); i = i+1)
		{
			LvarRSName	= LvarXmlTables.xmlChildren[i].xmlAttributes.name;
			LvarXmlCols = LvarXmlTables.xmlChildren[i].xmlChildren[1].xmlChildren[1].xmlChildren;
			LvarRSs[LvarRSName] = queryNew("");
			for (j = 1; j LTE arrayLen(LvarXmlCols); j = j+1)
			{
				LvarName = LvarXmlCols[j].xmlAttributes.name;
				LvarTypes[LvarRSName][LvarName]	= LvarXmlCols[j].xmlAttributes.type;
				queryAddColumn(LvarRSs[LvarRSName], LvarName, arrayNew(1));
			}
		}
		

		if ( StructKeyExists(LvarXML2["diffgr:diffgram"], "NewDataSet") )
		{
			// Llena datos
			LvarXmlData   = LvarXML2["diffgr:diffgram"]["NewDataSet"];
			for (i = 1; i LTE arrayLen(LvarXmlData.xmlChildren); i = i+1)
			{
				LvarRows 	= LvarXmlData.xmlChildren[i];
				LvarRSName	= LvarRows.xmlName;
				queryAddRow(LvarRSs[LvarRSName], 1);
				for (j = 1; j LTE arrayLen(LvarRows.xmlChildren); j = j+1)
				{
					LvarName = LvarRows.xmlChildren[j].xmlName;
					LvarType = LvarTypes[LvarRSName][LvarName];
					Lvar2ptos = Find(":",LvarType);
					if (Lvar2Ptos GT 0)
						LvarType = mid(LvarType,Lvar2ptos+1,100);
						
					LvarValue = LvarRows.xmlChildren[j].xmlText;
					try
					{
						if ( listFindNoCase("Byte,decimal,Double,Float,int,integer,long,negativeInteger,nonNegativeInteger,nonPositiveInteger,positiveInteger,short,unsignedByte,unsignedInt,unsignedLong,unsignedShort", LvarType) )
							LvarValue = val(LvarValue);
						else if ( listFindNoCase("Date,dateTime,time", LvarType) )
						{
							LvarValue = replace (LvarValue,"T"," ","ALL");
							Lvar2ptos = Find(".",LvarValue);
							if (Lvar2ptos GT 0)
								LvarValue = mid(LvarValue,1,Lvar2ptos-1);
							
							LvarValue = ParseDateTime(LvarValue);
						}
						else if (LCase(LvarType) EQ "boolean")
							LvarValue = ( NOT listFindNoCase(LvarValue, "no,false,0") );
						else if (LCase(LvarType) EQ "base64binary")
							LvarValue = toBinary(LvarValue);
					}
					catch (any e)
					{}
					querySetCell(LvarRSs[LvarRSName], LvarRows.xmlChildren[j].xmlName, LvarValue, LvarRSs[LvarRSName].recordCount);
				}
			}
		}
		return LvarRSs;
	}
</cfscript>
