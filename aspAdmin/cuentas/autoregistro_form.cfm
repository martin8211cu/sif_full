<form name="form1">
	<cfinclude template="autoregistro.cfm">
	<cfset LvarMax = 10>
	<cfset LvarNum = listtoarray("uno,dos,tres,cuatro,cinco,seis,siete,ocho,nueve,diez")>
	<cfset LvarHora1 = now()>
	<cfloop  index="i" from="1" to="#LvarMax#">
		<cfloop  index="j" from="1" to="10">
			<cfoutput>#Request.Translate(LvarNum[j],"Etiqueta " & LvarNum[j] & ":")#</cfoutput><br>
		</cfloop>
	</cfloop>
	<cfset LvarNum = listtoarray("Nayarit,Nuevo Le&oacute;n,Oaxaca,Puebla,Querétaro,Quintana Roo,San Luis Potos&iacute;,Sinaloa,Sonora,Tabasco")>

	<cfset LvarHora2 = now()>
	<cfloop  index="i" from="1" to="#LvarMax#">
		<cfloop  index="j" from="1" to="10">
			<cfquery name="rsLocale" datasource="sdc">
			  declare @id numeric
			  select @id=LOCid FROM LocaleValores where LOCdescripcion=<cfqueryparam cfsqltype="cf_sql_char" value="#LvarNum[j]#">
			  select LOCvalor FROM LocaleValores where LOCid=@id
			</cfquery>
			<cfoutput>Valor:#rsLocale.LOCvalor#</cfoutput><br>
		</cfloop>
	</cfloop>
	<cfset LvarHora3 = now()>
  <cfoutput> #LvarHora1#,#LvarHora2#,#LvarHora3#<br>
    XML = #DateDiff("s", LvarHora1, LvarHora2)#&nbsp;segundos<br>
    DB = #DateDiff("s", LvarHora2, LvarHora3)#&nbsp;segundos<br>
  </cfoutput> 
</form>