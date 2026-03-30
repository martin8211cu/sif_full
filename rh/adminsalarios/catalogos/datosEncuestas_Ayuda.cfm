<div class="Ayuda">
	<cfif form.PASO EQ "0">
	  <strong>Consola de Máquinas:</strong>
		<br>
		<br>
			La presente es una lista de las máquinas existentes en el sistema. 
			<br><br>
			Cada máquina posee una lista de impresoras y una lista de cajas.
			<br><br>
			Tanto la lista de impresoras como la lista de cajas cuenta con la opcion de incluir un nuevo registro 
			por medio del botón  que se encuentra en la parte inferior de cada lista.
			<br><br>
			Al final de la lista de máquinas, se encuentra un botón -Nueva Maquina- para incluir un
			registro nuevo de una máquina. 
   
			
		<br>
		<br>
	<cfelseif form.Paso EQ "1">
		<strong>Mantenimiento de Máquinas:</strong>
		<br>
		<br>
			La presente es una lista con las máquinas existentes en el sistema, usted puede modificar una de ellas o creae una nueva.
		<br>
		<br>
	<cfelseif form.Paso EQ "2">
		<strong>Adicionar Máquinas:</strong>
		<br>
		<br>
			La presente es una lista con las impresoras existentes en el sistema, usted puede modificar una de ellas o crear uno nueva.
		<br>
		<br>
	<cfelseif form.Paso EQ "3">
		<strong>Mantenimiento de Cajas:</strong>
		<br>
		<br>
			La presente es una lista con las cajas existentes en el sistema, usted puede modificar una de ellas o crear uno nueva.
		<br>
		<br>
	</cfif>
</div>
