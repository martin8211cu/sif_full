<cfcomponent>
    <cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>

	<cffunction name="get" returntype="Query">
		<cfargument name="ACAid" type="numeric" required="yes">
		<cfargument name="Activo" type="numeric" required="yes" default="0">
		<cfargument name="Long" type="boolean" default="false" required="no">
		<cfquery name="rs" datasource="#session.dsn#">
			select a.ACAid, a.DEid, a.ACAfechaIngreso, a.ACAfechaEgreso, 
				b.NTIcodigo, b.DEidentificacion, b.DEnombre, b.DEapellido1, b.DEapellido2, 
				{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,
				{fn concat(' ',{fn concat(b.DEnombre)})})})})} as DEnombreCompleto,
				<cfif Arguments.Long>
					b.Bid, b.CBTcodigo, b.DEcuenta, b.CBcc, b.Mcodigo, b.DEdireccion, 
					b.DEtelefono1, b.DEtelefono2, b.DEemail, b.DEcivil, b.DEfechanac, b.DEsexo, b.DEcantdep, 
                    b.DEobs1, b.DEobs2, b.DEobs3, b.DEdato1, b.DEdato2, b.DEdato3, b.DEdato4, b.DEdato5, 
                    b.DEinfo1, b.DEinfo2, b.DEinfo3, b.DEsistema, b.DEusuarioportal, b.DEtarjeta, 
                    b.Ppais, b.DEfanuales, b.DEfvacaciones, b.DEidcorp, b.DEporcAnticipo, b.DEobs4, b.DEobs5, 
					b.DEdato6, b.DEdato7, b.DEinfo4, b.DEinfo5,
                    lt.Tcodigo,lt.RHTid,lt.Ocodigo,lt.Dcodigo,lt.RHPid,
					lt.RHPcodigo,lt.RVid,lt.RHJid,lt.RHCPlinea,lt.LTdesde,
					lt.LThasta,lt.LTporcplaza,lt.LTsalario,lt.LTporcsal,
					lt.CPid,lt.IEid,lt.TEid,lt.Mcodigo,
				</cfif>
				case when LTdesde is not null then 1 else 0 end as Nombrado                
			from ACAsociados a
				inner join DatosEmpleado b
				on b.DEid = a.DEid
                left outer join LineaTiempo lt 
				on lt.DEid = a.DEid
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					between LTdesde and LThasta
			where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAid#">
			and ACAestado = 1
		</cfquery>
		<cfif rs.recordcount eq 0 and Arguments.Activo EQ 0>
			<cfquery name="rs" datasource="#session.dsn#">
				select 1
                from ACAsociados a
				where ACAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ACAid#">
				and ACAestado = 0
			</cfquery>
			<cfif rs.recordcount eq 1>
				<cfthrow  message="Error en Componente ACAsociados. M&eacute;todo Get. El Asociado est&aacute; Inactivo. Proceso Cancelado!">
			</cfif>
			<cfthrow  message="Error en Componente ACAsociados. M&eacute;todo Get. No se pudo Obtener el Asociado. Proceso Cancelado!">
		</cfif>
		<cfreturn rs>
	</cffunction>
</cfcomponent>