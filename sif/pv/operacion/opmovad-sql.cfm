<!--- 
	Movimiento de Adelantos
	Este proceso permite trasladar uno o más adelantos realizados por un cliente a otro. 
	El Proceso se realiza de la siguiente manera:
	1.	El Usuario ingresa el cliente origen (cliente que tiene el adelanto registrado actualmente) y solicita al sistema la lista de adelantos de dicho
		cliente.
	2.	El Sistema le muestra la lista de adelantos del cliente con cajas de selección múltiple para marcar los adelantos que se desea trasladar a otro 
		cliente.
	3.	El Usuario marca las cajas de selección múltiple correspondientes a los adelantos que desea trasladar y solicita iniciar el traslado al sistema.
	4.	El sistema muestra una lista resumen de los adelantos marcados, y solicita al usuario el cliente destino (cliente a quien se le quiere traspasar
		los adelantos), y solicita que autorice el traslado (botón de aplicar).
	5.	El cliente ingresa el cliente destino, el motivo de traslado, y le pide al sistema aplicar la transacción de traslado (***el sistema debe 
		solicitar confirmación al usuario ***).
	6.	El Sistema Realiza la transacción.
			NOTAS:
				1. FAX14CON DEBE MANEJARSE COMO UN CENSECUTIVO A PATA POR CDCCODIGO
	7.	El Sistema informa los resultados del proceso, de ser exitosos, debe mostrar un resumen del traslado realizado. De lo contrario debe mostrar el 
		error.
--->
<cfset DEBUG = FALSE>
<cfset FABTrasladoAdidList = "">
<!--- 6.	El Sistema Realiza la transacción.--->
<cftransaction>
	<cfloop list="#Form.FAX14CONLIST#" index="FAX14CON">
		<!--- 6.0 	Obtiene FAX14CONDEST --->
		<cfquery name="rsSelect1" datasource="#session.dsn#">
			SELECT coalesce(max(FAX14CON),0)+1 AS FAX14CONDEST
			FROM FAX014 
			WHERE 	CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.CDCcodigoDest#">
		</cfquery>
		<cfset FAX14CONDEST = rsSelect1.FAX14CONDEST>
		<!--- 6.1 	Inserta en FAX014 nuevo documento de adelanto --->
		<cfquery name="rsInsert1" datasource="#session.dsn#">
			INSERT INTO FAX014 (
					Ecodigo, CDCcodigo, FAX14CON, 
					FAX14DOC, FAX14TDC, FAX14CLA, 
					FAX14FEC, FAX14MON, FAX14MAP, 
					FAM01COD, FAX01NTR, Mcodigo, 
					CFcuenta, IdTipoAd, FAX14STS, 
					FAX14DRE, FAX14DRE2, TransExterna, 
					BMUsucodigo, fechaalta, TESDPaprobadoPendiente)
			SELECT Ecodigo, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FORM.CDCcodigoDest#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CONDEST#">, 
					
					FAX14DOC, 
					FAX14TDC, 
					FAX14CLA, 
					
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					FAX14MON-FAX14MAP, 
					0.00, 
					
					FAM01COD, 
					FAX01NTR, 
					Mcodigo, 
					
					CFcuenta, 
					IdTipoAd, 
					FAX14STS, 
					
					FAX14DRE, 
					FAX14DRE2, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.TransExterna#" null="#len(TransExterna) eq 0#">, 
					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					TESDPaprobadoPendiente
					
			FROM 	FAX014
			WHERE   FAX014.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				and FAX014.FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CON#">
				and FAX014.FAX14TDC in ('NC', 'AD')
				and FAX014.FAX14STS = '1'
				and FAX014.FAX14CLA in ('1','2')
				and FAX014.FAX14MAP = 0
		</cfquery>
		<!--- 6.2 	Inserta en FAX016 documento que cancela el adelanto de la FAX014 cancelada --->
		<cfquery name="rsInsert2" datasource="#session.dsn#">
			INSERT INTO FAX016 (
					Ecodigo, CDCcodigo, FAX16FEC, 
					FAX16MON, FAM01COD, FAX01NTR, 
					FAX16NDC, FAX16TIP, FAX16OBS, 
					FAX14CON, fechaalta, BMUsucodigo)
			SELECT Ecodigo, 
					CDCcodigo, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					
					FAX14MON-FAX14MAP, 
					null, 
					null, 
					
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FAX14CONDEST#">, 
					FAX14TDC, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FABMotivo#">, 
					
					FAX14CON, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					
			FROM 	FAX014
			WHERE   FAX014.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				and FAX014.FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CON#">
				and FAX014.FAX14TDC in ('NC', 'AD')
				and FAX014.FAX14STS = '1'
				and FAX014.FAX14CLA in ('1','2')
				and FAX014.FAX14MAP = 0
		</cfquery>
		<!--- 6.3 	Actualiza FAX014 y la pone como cancelada --->
		<cfquery name="rsUpdate1" datasource="#session.dsn#">
			UPDATE FAX014
				SET FAX14MAP = FAX14MON
			WHERE   FAX014.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
				and FAX014.FAX14CON = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CON#">
				and FAX014.FAX14TDC in ('NC', 'AD')
				and FAX014.FAX14STS = '1'
				and FAX014.FAX14CLA in ('1','2')
				and FAX014.FAX14MAP = 0
		</cfquery>
		<!--- 6.4 	Inserta en Bitáora de Movimientos --->
		<cfquery name="rsInsert3" datasource="#session.dsn#">
			INSERT INTO FABitacoraTrasladoAd (Ecodigo, FABMotivo, CDCcodigoOri, FAX14CONOri, CDCcodigoDest, FAX14CONDest, FABIP_Maquina, BMUsucodigo, 
				fechaalta)
			VALUES(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.FABMotivo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDCcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CON#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDCcodigoDest#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#FAX14CONDEST#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Sitio.IP#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsInsert3">
		<cfset FABTrasladoAdidList = FABTrasladoAdidList & iif(len(FABTrasladoAdidList),DE(","),DE("")) & rsInsert3.identity>
	</cfloop>
	<cfif DEBUG>
		<cfquery name="rsDebug" datasource="#session.dsn#">
			SELECT *
			FROM FAX014
		</cfquery>
		<cfdump var="#rsDebug#">
		<cfquery name="rsDebug" datasource="#session.dsn#">
			SELECT *
			FROM FAX016
		</cfquery>
		<cfdump var="#rsDebug#">
		<cfquery name="rsDebug" datasource="#session.dsn#">
			SELECT *
			FROM FABitacoraTrasladoAd
		</cfquery>
		<cfdump var="#rsDebug#">
		<cftransaction action="rollback"/>
	</cfif>
</cftransaction>
<cflocation url="opmovad.cfm?CDCcodigo=#form.CDCcodigo#&FABTrasladoAdidList=#FABTrasladoAdidList#"/>