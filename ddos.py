# Have fun!
import multiprocessing
from time import sleep
import math
import hashlib
import io

def collatz(n):
    steps = 0
    while n != 1:
        print(n, end=" → ")
        if n % 2 == 0:
            n = n // 2
        else:
            n = 3 * n + 1
        steps += 1
    print(1)
    return steps
def worker_task(process_id):
	i=1
	mem = io.BytesIO()
	while True:
		temp = (math.cos(math.factorial(i % 10)) / 
				math.tan(i % 5 + 0.1) / 
				math.pow(math.pi, math.log(i % 10 + 1)) + 
				math.gamma(i % 20 + 1) ** 0.5)
		print('DDOS -', i, process_id, 'hash:', hashlib.sha512(str(temp).encode()).hexdigest(), 'collatz:', collatz(i))
		mem.write(bin(math.factorial(i)).encode())
		i+=1
		sleep(0.1)
if __name__ == '__main__':
	processes = []
	for i in range(multiprocessing.cpu_count()):  # Match the number of CPU cores
		p = multiprocessing.Process(target=worker_task, args=(i,))
		processes.append(p)
		p.start()

	for p in processes:
		p.join()