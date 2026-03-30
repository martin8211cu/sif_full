<!--- 
 Archivo de Importaci�n de Indicadores por CF
 Archivo: 	ImportadorIndicadoresCF.cfm
 Creado: 	Randall Colomer en SOIN
 Fecha:     15 de Noviembre del 2006
 --->	

<!--- Valida que exista la Relaci�n --->
<cfif isdefined("form.Relacion") and len(trim(form.Relacion)) gt 0 and form.Relacion>
	<cfset form.REid = #form.Relacion#>
</cfif>

<!--- Variables --->	
<cfset validarCF = true>
<cfset valiedarNota = true>	

<!--- Valida que existan los CF en una Relaci�n existente ---> 
<cfquery name="rsValidarCF" datasource="#Session.Dsn#">
	select count(1) as Relacion
	from #table_name# tn
	where not exists (	select  1
						from RHCFGruposRegistroE  a
							inner join RHGruposRegistroE b
								on a.GREid = b.GREid 
							inner join CFuncional c
								on a.CFid = c.CFid		
								and c.CFcodigo = tn.CFcodigo		
						where b.REid = #form.REid# )
</cfquery>
<cfif rsValidarCF.Relacion GT 0 >
	<cfset validarCF = false>
</cfif>

<!--- Valida que las notas del archivo esten en un rando establecido --->
<cfquery name="rsValidarNota" datasource="#Session.Dsn#">
	select count(1) as Nota
	from #table_name#
	where (Nota < 0)
</cfquery>
<cfif rsValidarNota.Nota GT 0>
	<cfset valiedarNota = false>	
</cfif>

<!--- Valida que las variables sean correctas --->
<cfif validarCF and valiedarNota>
	<!--- Si las validaciones son correctas, actualiza las notas en la tabla RHNotasIndicadoresCF --->
	<cfquery name="rsActualizaNota" datasource="#Session.Dsn#">
		update RHNotasIndicadoresCF
		set Nota = #table_name#.Nota
		from #table_name#
			inner join CFuncional
				on  #table_name#.CFcodigo = CFuncional.CFcodigo
		where RHNotasIndicadoresCF.CFid = CFuncional.CFid
			and RHNotasIndicadoresCF.REid = #form.REid#
	</cfquery>

<cfelse>
	<!--- Si las validaciones son incorrectas, muestra los errores que tiene el archivo txt --->
	<cfif not validarCF or not valiedarNota>
		<cfquery name="ERR" datasource="#Session.Dsn#">
			select 'El Centro Funcional no esta en una Relacion' as MSG, tn.CFcodigo as Valor
			from #table_name# tn
			where not exists (	select  1
								from RHCFGruposRegistroE  a
									inner join RHGruposRegistroE b
										on a.GREid = b.GREid 
									inner join CFuncional c
										on a.CFid = c.CFid		
										and c.CFcodigo = tn.CFcodigo		
								where b.REid = #form.REid# )

			union

			select 'La Nota se encuentra fuera del rango permitido (>0)' as MSG, convert(varchar,Nota) as Valor
			from #table_name#
			where (Nota < 0)
		</cfquery>
	</cfif>
	
</cfif>
