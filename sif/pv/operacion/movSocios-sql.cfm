<cfinclude template="../../Utiles/sifConcat.cfm">
<cfoutput>
	<cftransaction>
		<cfloop list="#form.chk#" index="id">
			<!--- Insert de Registro de aplicación de Adelanto Original --->
			<cfquery datasource="#session.DSN#">
				insert into FAX016( Ecodigo,
									CDCcodigo,
									FAX16FEC,
									FAX16MON,
									FAM01COD,
									FAX16NDC,
									FAX16TIP,
									FAX16OBS,
									FAX14CON,
									fechaalta,
									BMUsucodigo)
				select 	Ecodigo,
						CDCcodigo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
						FAX14MON-FAX14MAP,
						FAM01COD,
						'N/A',
						'--',
						'Traslado de Adelanto a Cliente: ' #_Cat# ( select SNnombre
																 from SNegocios
																 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
																 and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">),
						FAX14CON,
						<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				from FAX014
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#"> <!--- CDCcodigo Origen --->
				  and FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">  <!--- FAX14CON (ConsecutivoAdelanto) --->
			</cfquery>
	
			<cfquery datasource="#session.DSN#">
				insert into Pagos(	Ecodigo, 
									CCTcodigo, 
									Pcodigo, 
									Ocodigo,
									Mcodigo,
									Ccuenta,  
									SNcodigo, 
									Ptipocambio, 
									Ptotal, 
									Pfecha, 
									Preferencia,
									Pobservaciones,
									Pusuario, 
									Seleccionado,
									BMUsucodigo )
				
				select 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">, 
						a.FAX14DOC, 
						b.Ocodigo,
						a.Mcodigo,
						c.Ccuenta,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">, 
						1,
						round(a.FAX14MON - a.FAX14MAP, 2), 
						a.FAX14FEC,
						'NC', 
						'Movimiento de Anticipos a Cuentas por Cobrar',
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">

				from FAX014 a 
				
				inner join FAM001 b
				on b.FAM01COD = a.FAM01COD 
				
				inner join  CFinanciera c
				on c.CFcuenta = a.CFcuenta
				
				where a.FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">
				  and a.CDCcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<!--- update de registro original --->
			<cfquery datasource="#session.DSN#">
				update FAX014 
				set FAX14MAP = FAX14MON, 
					FAX14STS = '2'
				where CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#"> <!--- CDCcodigo Origen --->
				  and FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id#">  <!--- FAX14CON (ConsecutivoAdelanto) --->
			</cfquery>		
		</cfloop>
	</cftransaction>
</cfoutput>

<cflocation url="movSocios-reporte.cfm?CDCcodigo=#form.CDCcodigo#&FAX14DOC=#form.FAX14DOC#&SNcodigo=#form.SNcodigo#&CCTcodigo=#form.CCTcodigo#&chk=#form.chk#&FABmotivo=#form.Fabmotivo#"/>