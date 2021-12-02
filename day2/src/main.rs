//rust 1.30.0 

use std::fs::File;
use std::io::{BufRead, BufReader, Error, ErrorKind, Read};
use std::ops::Add;

struct Position {
    horizontal: i32,
    depth: i32,
    aim: i32,
}

impl Add<Position> for Position {
    type Output = Position;

    fn add(self, _rhs: Position) -> Position  {
        Position {horizontal: self.horizontal + _rhs.horizontal, depth: self.depth + _rhs.depth, aim: self.aim + _rhs.aim}
    }
}

fn accumulate (sum: Result<Position, Error>, line: Result<String, Error>) -> Result<Position, Error> {
    match sum {
        Err(e) => Err(e),
        Ok(s) => match line {
            Err(e) => Err(e),
            Ok(l) => {
                let line_parts:Vec<&str> = l.split(" ").collect();
                let aim = s.aim;
                match line_parts[1].parse::<i32>() {
                    Err(e) => Err(Error::new(ErrorKind::InvalidData, e)),
                    Ok(v) => match line_parts[0] {
                        "forward" => Ok(s + Position {horizontal: v, depth: aim * v, aim: 0} ),
                        "up" => Ok(s + Position {horizontal: 0, depth: 0, aim: -v} ),
                        "down" => Ok(s + Position {horizontal: 0, depth: 0, aim: v} ),
                        _ => Err(Error::new(ErrorKind::InvalidData, "Non supported direction."))
                    }
                }
            }
        }
    }
}

fn read_and_sum<R: Read>(io: R) -> Result<Position, Error> {
    const ZERO_POSITION: Position = Position {horizontal: 0, depth: 0, aim: 0};
    let br = BufReader::new(io);
    br.lines().fold(Ok(ZERO_POSITION), accumulate)
}



fn main() -> Result<(), Error> {
    match read_and_sum(File::open("input.txt")?) {
        Ok(sum) => println!("{}",sum.horizontal * sum.depth),
        Err(error) => println!("Error: {:?}", error)
    }
    Ok(())
}
