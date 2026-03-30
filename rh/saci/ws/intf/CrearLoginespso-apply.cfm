<cfif isdefined("Form.enviar")>
	

	<cfif isdefined("form.rol") and form.rol eq 'AGENTE'>

		<cfquery datasource="SACISIIC" name="rsAgentes">
		 Select	Pquien,SERCLA as usuario
				
		from  SACISIIC..SSXLXV a 
				inner join SACI..SAI001 b
					on a.SERCLA = b.SAI01LOG
					and b.SAI01BOR = 0
				inner join SACI..SAI011 c
					on b.SAI01COD = c.SAI01COD
					inner join SACI..SAI007 d
					on c.SAI07COD = d.SAI07COD
				inner join isb..ISBpersona x
					on x.Pid = d.SAI07CED
					inner join SACISIIC..SSXVEN ag
					on a.VENCOD = ag.VENCOD
					and ag.VENEST = 'A'
					and ag.VENTIP = 'E'
		Where a.VENCOD in (select y.VENCOD from SACISIIC..SSXLXV y group by y.VENCOD having count(y.VENCOD) = 1)
		</cfquery>

		<cfoutput group="Pquien" query="rsAgentes">
			<cfoutput >	
			Creando Login... #usuario#
			<br />	
			<cfinvoke component="saci.ws.intf.crearLoginpso" method="crearLoginasp">
				<cfinvokeargument name="tipoGeneracion" value="#form.tipoGeneracion#">
				<cfinvokeargument name="user" value="#usuario#">
				<cfinvokeargument name="pass" value="#usuario#">
				<cfinvokeargument name="email" value="#usuario#@soin.co.cr">
				<cfinvokeargument name="Pquien" value="#Pquien#">
				<cfinvokeargument name="rol" value="AGENTE">
			</cfinvoke>
			</cfoutput>	
		</cfoutput>
	
	<cfelseif isdefined("form.rol") and form.rol eq 'VENDEDOR'>

		<cfquery datasource="SACISIIC" name="rsVendedores">
		Select x.Pquien,SERCLA as usuario
			from  SACISIIC..SSXLXV a 
				inner join SACI..SAI001 b
					on a.SERCLA = b.SAI01LOG
					and b.SAI01BOR = 0
				inner join SACI..SAI011 c
					on b.SAI01COD = c.SAI01COD
				inner join SACI..SAI007 d
					on c.SAI07COD = d.SAI07COD
				inner join ISBpersona x
					on x.Pid = d.SAI07CED
				inner join SACISIIC..SSXVEN ag
					on a.VENCOD = ag.VENCOD
					and ag.VENEST = "A"
					and ag.VENTIP = "E"
		Where a.VENCOD in (select y.VENCOD from SACISIIC..SSXLXV y group by y.VENCOD having count(y.VENCOD) > 1)
		</cfquery>

		<cfoutput group="Pquien" query="rsVendedores">
			<cfoutput >	
			Creando Login... #usuario#
			<br />	
			<cfinvoke component="saci.ws.intf.crearLoginpso" method="crearLoginasp">
				<cfinvokeargument name="tipoGeneracion" value="#form.tipoGeneracion#">
				<cfinvokeargument name="user" value="#usuario#">
				<cfinvokeargument name="pass" value="#usuario#">
				<cfinvokeargument name="email" value="#usuario#@soin.co.cr">
				<cfinvokeargument name="Pquien" value="#Pquien#">
				<cfinvokeargument name="rol" value="VENDEDOR">
			</cfinvoke>
			</cfoutput>	
		</cfoutput>
	<cfelse>
			<cfthrow message="Atención el rol que se desea asignar no existe.">
	</cfif>	

</cfif>
	
	
