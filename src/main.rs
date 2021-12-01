//rust 1.30.0 

use std::fs::File;
use std::io::{BufRead, BufReader, Error, ErrorKind, Read};

fn read<R: Read>(io: R) -> Result<Vec<u32>, Error> {
    let br = BufReader::new(io);
    br.lines()
        .map(|line| line.and_then(|v| v.parse().map_err(|e| Error::new(ErrorKind::InvalidData, e))))
        .collect()
}



fn main() -> Result<(), Error> {
    let vec = read(File::open("input.txt")?)?;
    // use `vec` for whatever
    let mut n:u32 = 0;
    for p in vec.windows(2) {
        n += (p[1] > p[0]) as u32;
    }
	//println!("{:?}", vec);
    println!("{}",n);
    Ok(())
}
