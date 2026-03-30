<cfif #modo# EQ "ALTA">
			<input type="submit" name="Alta" value="Agregar"  >
			<input type="reset" name="Limpiar" value="Limpiar" >
<cfelse>	
			<input type="submit" name="Cambio" value="Modificar"  >
			<input type="submit" name="Baja" value="Eliminar" onclick="javascript:return confirm('¿Desea Eliminar el Registro?');">
			<input type="submit" name="Nuevo" value="Nuevo" >
</cfif>