<cfquery name="rsGarantias" datasource="#Attributes.Conexion#">
	select b.Gid, b.EFid, b.Miso4217, b.Gtipo, b.Gref, b.Gmonto, b.Ginicio, b.Gvence, b.Gcustodio, b.Gestado, b.Gobs,
		   c.PQcodigo, c.PQnombre, a.Contratoid, a.CTcondicion
	from ISBproducto a
		left outer join ISBgarantia b
			on b.Contratoid = a.Contratoid
		inner join ISBpaquete c
			on c.PQcodigo = a.PQcodigo
	where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
	<cfif Attributes.vista EQ 1>
		and a.CTcondicion = 'C'
		<cfif ExisteContrato>
			and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
		</cfif>
	<cfelseif Attributes.vista EQ 2>
	and a.CTcondicion = '0'
	</cfif>
</cfquery>
	
  <input type="hidden" name="CTid" value="<cfif ExisteCuenta><cfoutput>#rsCuenta.CTid#</cfoutput></cfif>">    
	<cfset idCuenta = "">
	<cfif ExisteCuenta>
		<cfset idCuenta = rsCuenta.CTid>
	</cfif>
	<cfset llaveGid = "">	
	<cfset llaveDepoGaran = "">	
	<cfset listaSuf = "">	
	
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
	<cfif isdefined('rsGarantias') and rsGarantias.recordCount GT 0>
		<cfloop query="rsGarantias">
			<cfif rsGarantias.currentRow NEQ 1>
				<tr>
				  <td>
					<hr />
				  </td>
				</tr>
			</cfif>
			<cfif rsGarantias.Gid NEQ ''>
				<cfset llaveGid = rsGarantias.Gid>
				<cfif len(trim(listaSuf))>
					<cfset listaSuf=listaSuf & ',_' & llaveGid>						
				<cfelse>
					<cfset listaSuf='_' & llaveGid>
				</cfif>				
				<cfset llaveDepoGaran = '_' & llaveGid>			
			</cfif>						
			<tr>
			  <td>
				<cf_depoGaran
					CTid="#idCuenta#"
					idpersona="#Attributes.idpersona#"
					idcontrato="#rsGarantias.Contratoid#"
					PQcodigo="#rsGarantias.PQcodigo#"
					Gid="#llaveGid#"
					verOpciones = "#Attributes.vista EQ 1 or Attributes.vista EQ 3#"
					sufijo="#llaveDepoGaran#">
			  </td>
			</tr>			
		</cfloop>	
	<cfelse>
		<cfset session.saci.depositoGaranOK = false>	
	</cfif>
	<input type="hidden" name="listaSuf" value="<cfoutput>#listaSuf#</cfoutput>">
  </table>