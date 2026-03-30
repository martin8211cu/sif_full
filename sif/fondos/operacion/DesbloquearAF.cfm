<cfif isdefined("Url.LvarCedula") and isdefined("Url.LvarPlaca")>


	<cfquery datasource="#session.Fondos.dsn#" name="desbloquear_AF">
	set nocount on

	declare
		@error int

	exec @error = sif_interfaces..sp_Bloqueo_Activo
	@bloquear		= 0,
	@DEidentificacion	= '#trim(Url.LvarCedula)#',
	@CRDRplaca		= '#trim(Url.LvarPlaca)#'

	if @error <> 0 or @@error <> 0 begin						
		return
	end 

	set nocount off
	</cfquery>

</cfif>
