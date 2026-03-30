<cfif isdefined("form.IDDISTRIBUCION") and len(trim(form.IDDISTRIBUCION))>
	<cfset Lvar_IDDISTRIBUCION = form.IDDISTRIBUCION>
</cfif>

<cfif isdefined("form.CBOTIPO") and len(trim(form.CBOTIPO))>
	<cfset Lvar_CBOTIPO = form.CBOTIPO>
</cfif>

<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<!--- valida que el archivo tenga registros --->
<cfquery name="rsCheck1" datasource="#session.DSN#">
	select count(*)
	from #table_name# 
</cfquery>

<cfif rsCheck1.RecordCount gt 0>
	<!--- valida que la oficina sea valida --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select <cf_dbfunction name='concat' args="'la oficina (' + x.Oficodigo + ')  no existe'" delimiters='+'>,2
		from #table_name# x
			where not exists (
				select 1 from Oficinas h 
				where h.Ecodigo		= #session.Ecodigo#
				  and h.Oficodigo	= x.Oficodigo
			)
	</cfquery>
	<!--- valida que la oficina no se repita cuando es de tipo origen --->
    <cf_dbfunction name= 'string_part' args= "x.Oficodigo,1,4" returnvariable='LvarSTR'>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name='concat' args="'la oficina ('+ #LvarSTR# +')  se encuentra repetida y la cuenta es de tipo Origen '" delimiters='+'>,3
		from #table_name# x 
		where upper(x.Tipo) = 'O' 
		group by Oficodigo
		having count(Oficodigo) > 1	
		
	</cfquery>
	<!--- valida que la cuenta mayor sea valida  (Cuenta)--->
    <cf_dbfunction name= 'string_part' args= "x.CDformato,1,4" returnvariable='LvarSTR'>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select <cf_dbfunction name='concat' args="'la cuenta mayor ('+ #LvarSTR# +') no existe '" delimiters='+'>,4  
		from #table_name# x
			where not exists (
				select 1 from CtasMayor h 
				where h.Ecodigo = #session.Ecodigo#
				and h.Cmayor =  <cf_dbfunction name="sPart"	args="x.CDformato,1,4">
			)	
	</cfquery>
	<!--- valida que la cuenta mayor sea valida  (complementaria)--->
    <cf_dbfunction name= 'string_part' args= "x.CDcomplemento,1,4" returnvariable='LvarSTR'>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select <cf_dbfunction name='concat' args="'la cuenta mayor (' + #LvarSTR# + ') no existe '" delimiters='+'>,5  
		from #table_name# x
			where not exists (
				select 1 from CtasMayor h 
				where h.Ecodigo = #session.Ecodigo#
				and h.Cmayor =  <cf_dbfunction name="sPart"	args="x.CDcomplemento,1,4">
			)			
	</cfquery>	
	<!--- valida que las cuentas mayor de cuenta y complementaria sean iguales --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum) 
		select <cf_dbfunction name='concat' args="'la cuenta ('+ x.CDformato +') y el complemento ('+ x.CDcomplemento +')  tienen la cuenta mayor diferente '" delimiters='+'>,6 
		from #table_name# x
		where  x.CDcomplemento is not null 
		and <cf_dbfunction name="sPart"	args="x.CDcomplemento,1,4"> != <cf_dbfunction name="sPart"	args="x.CDformato,1,4">
	</cfquery>	
	<!--- valida que la cuenta no se repita cuando es de tipo origen --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name='concat' args="'la cuenta ('+ x.CDformato +')  se encuentra repetido y es de tipo Origen '" delimiters='+'>,7
		from #table_name# x
		where upper(x.Tipo) = 'O' 
		group by CDformato
		having count(CDformato) > 1	
		
	</cfquery>	
	<!--- valida que la cuenta no se repita cuando es de tipo origen --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name='concat' args="'la cuenta ('+ x.CDformato +') oficina ('+ x.Oficodigo +') que es de tipo origen, ya se encuentra agregada. '" delimiters='+'>,8
		from #table_name# x
		where  exists (
			  select 1 from Oficinas o 
				inner join DCCtasOrigen b 
					 on b.Ocodigo = o.Ocodigo
                    and b.Ecodigo = o.Ecodigo
					and b.IDdistribucion = #Lvar_IDDISTRIBUCION# 
			   where upper(x.Tipo) = 'O'
                and ltrim(rtrim(b.CDformato)) = ltrim(rtrim(x.CDformato))
				and  ltrim(rtrim(x.Oficodigo)) = ltrim(rtrim(o.Oficodigo))
				and  o.Ecodigo = #session.Ecodigo#
		)
	</cfquery>	
	<!--- valida que la cuenta no se repita cuando es de tipo destino en una misma oficina --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name='concat' args="'la cuenta ('+ x.CDformato +')  se encuentra repetida en la oficina ('+ x.Oficodigo +') y es de tipo Destino '" delimiters='+'>,9
		from #table_name# x
		group by Oficodigo,CDformato,x.Tipo
		having count(CDformato) > 1	
		and  upper(x.Tipo) = 'D' 
	</cfquery>	
	<!--- valida que la cuenta no se repita cuando es de tipo destino --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		select distinct <cf_dbfunction name='concat' args="'la cuenta ('+ x.CDformato +') oficina ('+ x.Oficodigo +') que es de tipo destino, ya se encuentra agregada. '" delimiters='+'>,10
		from #table_name# x
		where  exists (
			  select 1 from Oficinas o 
				inner join DCCtasDestino b 
					 on b.Ocodigo = o.Ocodigo
                    and b.Ecodigo = o.Ecodigo
					and b.IDdistribucion = #Lvar_IDDISTRIBUCION# 
			   where upper(x.Tipo) = 'D'
               	and ltrim(rtrim(b.CDformato)) = ltrim(rtrim(x.CDformato))
				and  ltrim(rtrim(x.Oficodigo)) = ltrim(rtrim(o.Oficodigo))
				and  o.Ecodigo = #session.Ecodigo#
		)
	</cfquery>			
	
	
	<cfquery name="RS_Cuentas" datasource="#session.DSN#">
		select x.CDcomplemento,x.CDformato , b.Cmascara,b.Cmayor
		from #table_name# x
		inner join CtasMayor b
		 on   <cf_dbfunction name="sPart"	args="x.CDformato,1,4"> = b.Cmayor
		 and  b.Ecodigo = #session.Ecodigo#
	</cfquery>	
	<cfloop query="RS_Cuentas">
		<cfset Mascara 		= ListToArray(RS_Cuentas.Cmascara, "-")> 
		<cfset formato 		= ListToArray(RS_Cuentas.CDformato, "-")> 

		<cfif #ArrayLen(formato)# gt #ArrayLen(Mascara)#>
			<cfquery name="INS_Error" datasource="#session.DSN#">
					insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
					values(
					'(Campo Cuenta) La cuenta mayor #RS_Cuentas.Cmayor# tiene la siguiente mascara (#RS_Cuentas.Cmascara#) y se esta importando con mas  niveles (#RS_Cuentas.CDformato#)',11)
			</cfquery>		
		<cfelseif  #ArrayLen(formato)# lt #ArrayLen(Mascara)#>
			<cfquery name="INS_Error" datasource="#session.DSN#">
					insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
					values(
					'(Campo Cuenta) La cuenta mayor #RS_Cuentas.Cmayor# tiene la siguiente mascara (#RS_Cuentas.Cmascara#) y se esta importando con menos  niveles (#RS_Cuentas.CDformato#)',12)
			</cfquery>
		<cfelse>	
			<cfloop index="FIndex" from="1" to="#ArrayLen(Mascara)#">
				<cfif len(trim(Mascara[FIndex])) neq len(trim(formato[FIndex]))>
					<cfquery name="INS_Error" datasource="#session.DSN#">
						insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
						values(
						'(Campo Cuenta #RS_Cuentas.CDformato#) La cuenta mayor (#RS_Cuentas.Cmayor#) en el nivel (#FIndex#) la mascara completa es de #len(trim(Mascara[FIndex]))# y se esta importando con  #len(trim(formato[FIndex]))# (#formato[FIndex]#) ',15)
					</cfquery>
				</cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("RS_Cuentas.CDcomplemento") and len(trim(RS_Cuentas.CDcomplemento))>
				<cfset complemento 	= ListToArray(RS_Cuentas.CDcomplemento,"-")> 
				<cfif #ArrayLen(complemento)# gt #ArrayLen(Mascara)#>
					<cfquery name="INS_Error" datasource="#session.DSN#">
							insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
							values(
							'(Campo complemento) La cuenta mayor #RS_Cuentas.Cmayor# tiene la siguiente mascara (#RS_Cuentas.Cmascara#) y se esta importando con mas  niveles (#RS_Cuentas.CDcomplemento#)',13)
					</cfquery>		
				<cfelseif  #ArrayLen(complemento)# lt #ArrayLen(Mascara)#>
					<cfquery name="INS_Error" datasource="#session.DSN#">
							insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
							values(
							'(Campo complemento) La cuenta mayor #RS_Cuentas.Cmayor# tiene la siguiente mascara (#RS_Cuentas.Cmascara#) y se esta importando con menos  niveles (#RS_Cuentas.CDcomplemento#)',14)
					</cfquery>
				<cfelse>
					<cfloop index="CIndex" from="1" to="#ArrayLen(Mascara)#">
						<cfif len(trim(Mascara[CIndex])) neq len(trim(formato[CIndex]))>
							<cfquery name="INS_Error" datasource="#session.DSN#">
								insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
								values(
								'(Campo complemento #RS_Cuentas.CDcomplemento#) La cuenta mayor (#RS_Cuentas.Cmayor#) en el nivel (#CIndex#) la mascara completa es de #len(trim(Mascara[CIndex]))# y se esta importando con  #len(trim(formato[CIndex]))# (#formato[CIndex]#) ',16)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>

		</cfif>
	</cfloop> 
<cfelse>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importación no tiene registros',1)
	</cfquery>
</cfif>
<cfquery name="err" datasource="#session.dsn#">
	select Mensaje
	from #ERRORES_TEMP#
	order by ErrorNum,Mensaje
</cfquery>
<cfif (err.recordcount) EQ 0>
	<!--- incia proceso de importación--->

	<!--- DCCtasDestino --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into DCCtasDestino (IDdistribucion,Ecodigo,Ocodigo,CDformato,CDporcentaje,CDexcluir,CDcomplemento)
		select 
		#Lvar_IDDISTRIBUCION# as IDdistribucion,
		#session.Ecodigo#,
		o.Ocodigo,
		x.CDformato,
		<!---1 - Distribución por Movimientos del Mes de las cuentas destino--->
		<cfif Lvar_CBOTIPO eq 1>
			0,	
		<!---2 - Distribución por Movimientos del Mes X porcentaje dado--->
		<cfelseif  Lvar_CBOTIPO eq 2>
			coalesce(x.CDporcentaje,0),
		<!---3 - Distribución Equitativa de las cuentas destino--->
		<cfelseif  Lvar_CBOTIPO eq 3>
			0,
		<!---4 - Distribución por Peso dado--->
		<cfelseif  Lvar_CBOTIPO eq 4>
			0,
		<cfelse>
			<cfthrow message="Tipo de Distribución no implementada en este importador">
		</cfif>
		case coalesce(upper(x.Excluir),'N') when 'S' then 1 else 0 end  as CDexcluir,
		x.CDcomplemento
		from #table_name# x
		inner join Oficinas o
			  on  ltrim(rtrim(x.Oficodigo)) = ltrim(rtrim(o.Oficodigo))
			 and  o.Ecodigo = #session.Ecodigo#	
		where  upper(x.Tipo) = 'D'
	</cfquery>	
	<!--- DCCtasOrigen --->
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into DCCtasOrigen (IDdistribucion,Ecodigo,Ocodigo,CDformato,CDporcentaje,CDcomplemento)
		select 
		#Lvar_IDDISTRIBUCION# as IDdistribucion,
		#session.Ecodigo#,
		o.Ocodigo,
		x.CDformato,
		coalesce(x.CDporcentaje,0),	
		x.CDcomplemento
		from #table_name# x
		inner join Oficinas o
			  on  ltrim(rtrim(x.Oficodigo)) = ltrim(rtrim(o.Oficodigo))
			 and  o.Ecodigo = #session.Ecodigo#	
		where  upper(x.Tipo) = 'O'
	</cfquery>	
</cfif>