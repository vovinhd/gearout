func count_nodes(ref, type):

	var count = 0

	for node in ref.get_children():
		if(node.is_type(type)): 
			count += 1

	return count
