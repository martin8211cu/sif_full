<!--- poner en refer el menu padre --->
<cfquery datasource="asp" name="grupo">
	select 	SMNcodigo as valor, 
			{fn concat({fn concat({fn concat(SScodigo, SMcodigo)}, ':')}, SMNtitulo)} as descr,				<!---SScodigo || SMcodigo || ':' || SMNtitulo--->
			{fn concat({fn concat(rtrim(SScodigo), '.')}, rtrim(SMcodigo))} as grupo, <!--- rtrim(SScodigo) || '.' || rtrim(SMcodigo)--->
			'' as refer
	from SMenues
	where SMNtitulo is not null
	order by 1
</cfquery>